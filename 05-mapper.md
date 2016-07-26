
---
layout: page
title: Introduction to Hadoop
subtitle: Creating a Mapper
minutes: 20
---
> ## Learning Objectives {.objectives}
>
> *   Understand the process of viewing data in terms of Key/Value pair
> *   Understand the process of going backward from the desired answer to
>     the logic for reducer and then mapper
> *   Create python-based mapper function and test against non-Hadoop input

Now that we are familiar with Hadoop basic commands, it is time to revisit the
initial analyses on the movie dataset. Let's start with one simple analysis,
which is to find rating averages of movies over the years.

We first examine the structure of data file via http://files.grouplens.org/datasets/movielens/ml-10m-README.html
The output of this file should be visible in Jupyter's output box. You can
toggle scrolling of this output instead of having a lengthy window by clicking
on Cells/Current Outputs/Toggle Scrolling on the Menu bar. 

**User Ids**

Movielens users were selected at random for inclusion. Their ids have been anonymized. Users were selected separately 
for inclusion in the ratings and tags data sets, which implies that user ids may appear in one set but not the other. 
The anonymized values are consistent between the ratings and tags data files. That is, user id n, if it appears in 
both files, refers to the same real MovieLens user. 

**Ratings Data File Structure** 

All ratings are contained in the file ratings.dat. Each line of this file represents one rating of one movie by one user, and has the following format: 

UserID::MovieID::Rating::Timestamp 

The lines within this file are ordered first by UserID, then, within user, by MovieID. Ratings are made on a 5-star scale, with half-star increments. 

Timestamps represent seconds since midnight Coordinated Universal Time (UTC) of January 1, 1970. 

**Tags Data File Structure** 

All tags are contained in the file tags.dat. Each line of this file represents one tag applied to one movie by one
user, and has the following format: 

UserID::MovieID::Tag::Timestamp 

The lines within this file are ordered first by UserID, then, within user, by MovieID. Tags are user generated 
metadata about movies. Each tag is typically a single word, or short phrase. The meaning, value and purpose of a 
particular tag is determined by each user. 

Timestamps represent seconds since midnight Coordinated Universal Time (UTC) of January 1, 1970. 

**Movies Data File Structure** 

Movie information is contained in the file movies.dat. Each line of this file represents one movie, and has the following format: 

MovieID::Title::Genres 

MovieID is the real MovieLens id. 

Movie titles, by policy, should be entered identically to those found in IMDB, including year of release. 
However, they are entered manually, so errors and inconsistencies may exist. Genres are a pipe-separated list, 
and are selected from the following: 

-   Action
-   Adventure
-   Animation
-   Children's
-   Comedy
-   Crime
-   Documentary
-   Drama
-   Fantasy
-   Film-Noir
-   Horror
-   Musical
-   Mystery
-   Romance
-   Sci-Fi
-   Thriller
-   War
-   Western

To find the rating averages of movies, we will need to look at the
**ratings.csv** file. In this case, the dataset's README has provided extensive
details about the structure of the file. In the case when a README is not
available or inadequate, you can attempt to discern this information by looking
at the data itself. It is important to note that you do not want to view the
entire file (if it is stored in Hadoop, it is going to be HUGE). Since HDFS
does not have a **head** function, you can call **-cat** but pipe the results
through the Linux system's **head** function to cut off the output stream at
the number of lines you want to review.


```python
!ssh dsciu001 hdfs dfs -cat /user/lngo/intro-to-hadoop/ml-10M100K/ratings.dat \
    2>/dev/null | head -n 10
```

    1::122::5::838985046
    1::185::5::838983525
    1::231::5::838983392
    1::292::5::838983421
    1::316::5::838983392
    1::329::5::838983392
    1::355::5::838984474
    1::356::5::838983653
    1::362::5::838984885
    1::364::5::838983707


For any specific job/task that requires MapReduce, the inevitable question is
what is the Key/Value pair the mapper should produce such that the collection
of Values for each unique Key at the reducer is suitable for the operation that
would generate the final required results. One approach to address this question
is to traverse backward from the required results. In our case, we want to find
the rating average of each movie within the dataset. It is intuitive then to
assume that a movie should be the KEY, and the collection of VALUES is the
collection of ratings across the entire data set for this movie. Therefore, the
KEY/VALUE pair emitted by the mapping process should be movie/rating. Based on
the structure of the **ratings.csv** file, this is equivalent to emitting the
elements at the second and third columns as KEY and VALUE, respectively.  

Under Jupyter's main page, select New and open new Terminal. This will pop up an
additional browser tab with a terminal to your allocated Palmetto node. Within
this terminal, navigate to the **intro-to-hadoop** directory and create a Python
file named mapper01.py with the following content:

~~~ {.bash}
#!/usr/bin/env python                                          
import sys                                                                                                
for oneMovie in sys.stdin:                                                                            
  oneMovie = oneMovie.strip()                                                  
  ratingInfo = oneMovie.split("::")                                                                       
  movieID = ratingInfo[1]                                                                               
  rating = ratingInfo[2]                                                                                 
  print ('%s\t%s' % (movieID, rating))           
~~~

We can test this mapper file by using Linux pipe and HDFS' **cat** command in
the following manner.


```python
!ssh dsciu001 hdfs dfs -cat /user/lngo/intro-to-hadoop/ml-10M100K/ratings.dat \
    2>/dev/null | head -n 10 | python /home/lngo/intro-to-hadoop/mapper01.py
```

    122	5
    185	5
    231	5
    292	5
    316	5
    329	5
    355	5
    356	5
    362	5
    364	5


The mapping output looks good, but it does not carry as much information as we
would like. As it is, this intermediate data will enable reducers to calculate
the average ratings associated with movieId. While this is technically correct,
it still requires additional processing to associate the IDs with the movie
titles themselves. Is it possible for us to do this step within the mapper?
Reexamining the README, we see that movieIds are associated with titles in the
**movies.dat** file. Also, this file is much smaller than the **ratings.dat**
file. Looking forward into the future, we can see that this difference in size
can only be widened, as there can only be hundreds to thousands of new movies
each year, but there will be significantly more people reviewing each movie
each year. Therefore, it is reasonable to have each **individual mapper** to go
ahead and load **movies.dat** as dictionary in order to associate each processed
movieId with the appropriate title.

It is easier to have **movies.dat** available to be loaded from the Linux
file system.


```python
!ssh dsciu001 hdfs dfs -get /user/lngo/intro-to-hadoop/ml-10M100K/movies.dat /home/lngo/intro-to-hadoop 2>/dev/null
!ls /home/lngo/intro-to-hadoop
```

    mapper01.py  mapper03.py  ml-10m.zip  movies.dat
    mapper02.py  ml-10M100K   movies.csv  reducer01.py


The easiest way to streamline the association process is to read the
**movies.csv** file as a Python dictionary. Create a Python file named
**mapper02.py** with the following content:

~~~ {.bash}
#!/usr/bin/env python   
import os
import sys            
import csv                                                       
movieFile = os.path.join(os.path.dirname(sys.argv[0]),"movies.dat")
movieList = {}
with open(movieFile, mode = 'r') as infile:
  for line in infile:
    row = (line.strip()).split("::")
    movieList[row[0]] = {}  
    movieList[row[0]]["title"] = row[1].strip()  
    movieList[row[0]]["genre"] = row[2].strip()                       
for oneMovie in sys.stdin:                                     
  oneMovie = oneMovie.strip()      
  ratingInfo = oneMovie.split("::")               
  try:
    movieTitle = movieList[ratingInfo[1]]["title"]   
    rating = float(ratingInfo[2])                     
    print ("%s\t%s" % (movieTitle, rating))    
  except ValueError:                           
    continue               
~~~


```python
!ssh dsciu001 hdfs dfs -cat /user/lngo/intro-to-hadoop/ml-10M100K/ratings.dat 2>/dev/null \
    | head -n 10 | python /home/lngo/intro-to-hadoop/mapper02.py
```

    Boomerang (1992)	5.0
    Net, The (1995)	5.0
    Dumb & Dumber (1994)	5.0
    Outbreak (1995)	5.0
    Stargate (1994)	5.0
    Star Trek: Generations (1994)	5.0
    Flintstones, The (1994)	5.0
    Forrest Gump (1994)	5.0
    Jungle Book, The (1994)	5.0
    Lion King, The (1994)	5.0


It should be noted that the variable ***movieFile*** is opened using a path relative to the **mapper02.py** file. This is an important detail that will be necessary for running the MapReduce process on an actual Hadoop cluster. 


> ## Data Checking {.callout}
>
> Notice the .strip() statement. Leading and trailing white spaces are among the
> most common potential errors, especially when dealing with textual data.

We are now ready to funnel this data into a reducer.

## Check your understanding: Map genres to ratings {.challenge}
Another useful information to the movie company is not about the average ratings
of movies, but the average ratings of the genres. Write a mapper program called
**mapGenre.py** to associate the rating information of the movies to their
respective genres. A movie can belong to several genres, and its rating will be
counted as the rating for each of its genres.
