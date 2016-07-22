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

We first examine the structure of data file via README.txt.

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat /repository/movielens/README.txt
~~~

The output of this file should be visible in Jupyter's output box. You can
toggle scrolling of this output instead of having a lengthy window by clicking
on Cells/Current Outputs/Toggle Scrolling on the Menu bar.

To find the rating averages of movies, we will need to look at the
**ratings.csv** file. In this case, the dataset's README has provided extensive
details about the structure of the file. In the case when a README is not
available or inadequate, you can attempt to discern this information by looking
at the data itself. It is important to note that you do not want to view the
entire file (if it is stored in Hadoop, it is going to be HUGE). Since HDFS
does not have a **head** function, you can call **-cat** but pipe the results
through the Linux system's **head** function to cut off the output stream at
the number of lines you want to review.

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat /repository/movielens/ratings.csv  2>/dev/null | head -n 10
~~~

~~~ {.output}
userId,movieId,rating,timestamp
1,169,2.5,1204927694
1,2471,3.0,1204927438
1,48516,5.0,1204927435
2,2571,3.5,1436165433
2,109487,4.0,1436165496
2,112552,5.0,1436165496
2,112556,4.0,1436165499
3,356,4.0,920587155
3,2394,4.0,920586920
cat: Unable to write to output stream.
~~~

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
  ratingInfo = oneMovie.split(",")                                                                       
  movieID = ratingInfo[1]                                                                               
  rating = ratingInfo[2]                                                                                 
  print ('%s\t%s' % (movieID, rating))           
~~~

We can test this mapper file by using Linux pipe and HDFS' **cat** command in
the following manner.

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat /repository/movielens/ratings.csv 2>/dev/null | head -n 10 | python mapper01.py
~~~

~~~ {.output}
movieId	rating
169	2.5
2471	3.0
48516	5.0
2571	3.5
109487	4.0
112552	5.0
112556	4.0
356	4.0
2394	4.0
cat: Unable to write to output stream.
~~~

This program produces the KEY/VALUE pairs that we want, but it also produces
something that we do not want, the movieId/rating pair, which was parsed from
the first line of **ratings.csv**.


## Check your understanding: Filtering and error checking on mapper {.challenge}

The output of the current mapper contains the headers for movieId and rating.
Modify the mapper01.py file to filter out these values. Name the new file
mapper02.py

> ## Data Checking {.callout}
>
> As data become massive, the probability of having bad data also increases
> accordingly. It is important that you are at least aware of potential bad
> values (i.e, missing data, error messages instead of numeric values, ...)
> and design error-checking into the mapping process. While error-checking can
> also be done by reducers, mappers have a much higher degree of concurrency
> and can be more efficient in data cleaning. Furthermore, we do not want to
> waste bandwidth sending out bad data.

Output of mapper02 with error checking message

~~~ {.output}
Invalid ID/rating: movieId rating
169.0	2.5
2471.0	3.0
48516.0	5.0
2571.0	3.5
109487.0	4.0
112552.0	5.0
112556.0	4.0
356.0	4.0
2394.0	4.0
cat: Unable to write to output stream.
~~~

Output of mapper02 without error checking messages

~~~ {.output}
169.0	2.5
2471.0	3.0
48516.0	5.0
2571.0	3.5
109487.0	4.0
112552.0	5.0
112556.0	4.0
356.0	4.0
2394.0	4.0
cat: Unable to write to output stream.
~~~

The mapping output looks good, but it does not carry as much information as we
would like. As it is, this intermediate data will enable reducers to calculate
the average ratings associated with movieId. While this is technically correct,
it still requires additional processing to associate the IDs with the movie
titles themselves. Is it possible for us to do this step within the mapper?
Reexamining the README, we see that movieIds are associated with titles in the
**movies.csv** file. Also, this file is much smaller than the **ratings.csv**
file. Looking forward into the future, we can see that this difference in size
can only be widened, as there can only be hundreds to thousands of new movies
each year, but there will be significantly more people reviewing each movie
each year. Therefore, it is reasonable to have each **individual mapper** to go
ahead and load **movies.csv** as dictionary in order to associate each processed
movieId with the appropriate title.

It is easier to have **movies.csv** available to be loaded from the Linux
file system.

~~~ {.bash}
$ !ssh dsciu001 hdfs dfs -get /repository/movielens/movies.csv /home/<username>/intro-to-hadoop
~~~

The easiest way to streamline the association process is to read the
**movies.csv** file as a Python dictionary. Create a Python file named
**mapper03.py** with the following content:

~~~ {.bash}
#!/usr/bin/env python          
import sys            
import csv                                                       
movieFile = "movies.csv"
movieList = {}
with open(movieFile, mode = 'r') as infile:
  reader = csv.reader(infile)
    for row in reader:  
      movieList[row[0]] = {}  
      movieList[row[0]]["title"] = row[1].strip()  
      movieList[row[0]]["genre"] = row[2].strip()                       
for oneMovie in sys.stdin:                                     
  oneMovie = oneMovie.strip()      
  ratingInfo = oneMovie.split(",")               
  try:
    movieTitle = movieList[ratingInfo[1]]["title"]   
    rating = float(ratingInfo[2])                     
    print ("%s\t%s" % (movieTitle, rating))    
  except ValueError:                           
    continue                 
~~~

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat /repository/movielens/ratings.csv 2>/dev/null | head -n 10 | python mapper03.py
~~~

~~~ {.output}
Free Willy 2: The Adventure Home (1995)	2.5
Crocodile Dundee II (1988)	3.0
Departed, The (2006)	5.0
Matrix, The (1999)	3.5
Interstellar (2014)	4.0
Whiplash (2014)	5.0
Gone Girl (2014)	4.0
Forrest Gump (1994)	4.0
Prince of Egypt, The (1998)	4.0
cat: Unable to write to output stream.
~~~

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
