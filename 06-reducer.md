---
layout: page
title: Introduction to Hadoop
subtitle: Creating a Reducer
minutes: 15
---
> ## Learning Objectives {.objectives}
>
> *   Create python-based reducer function and test against non-Hadoop input

Each reducer will process a collection of KEYS, each KEY associated with a set
of VALUEs. It should be noted that in a Python-based Hadoop Streaming
environment, intermediate data come into each reducer not as a collection of
separated KEY/VALUES groups, but still as a single stream of data whose elements
are sorted by KEYs. Create a Python file named **reducer01.py** with the
following content:


~~~ {.bash}
#!/usr/bin/env python
import sys

current_movie = None
current_rating_sum = 0
current_rating_count = 0

for line in sys.stdin:
  line = line.strip()
  movie, rating = line.split("\t", 1)
  try:
    rating = float(rating)
  except ValueError:
    continue

  if current_movie == movie:
    current_rating_sum += rating
    current_rating_count += 1
  else:
    if current_movie:
      rating_average = current_rating_sum / current_rating_count
      print ("%s\t%s" % (current_movie, rating_average))
    current_movie = movie
    current_rating_sum = rating
    current_rating_count = 1

if current_movie == movie:
  rating_average = current_rating_sum / current_rating_count
  print ("%s\t%s" % (current_movie, rating_average))
~~~

To test this script on non-Hadoop data, we can run the following command:

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat /repository/movielens/ratings.csv 2>/dev/null | head -n 10 | python mapper03.py | sort | python reducer01.py
~~~

~~~ {.output}
Crocodile Dundee II (1988)	3.0	1
Departed, The (2006)	5.0	1
Forrest Gump (1994)	4.0	1
Free Willy 2: The Adventure Home (1995)	2.5	1
Gone Girl (2014)	4.0	1
Interstellar (2014)	4.0	1
Matrix, The (1999)	3.5	1
Prince of Egypt, The (1998)	4.0	1
Whiplash (2014)	5.0	1
~~~

The **sort** pipe in the middle will sort all the intermediate data coming from
the mapper, effectively emulate Hadoop's shuffle behavior. This test is somewhat
meaningless, as it only tells us that there is no error in our reduce code, but
it does not tell us whether our reducer works correctly or not. We need to test
for the following:
1. Do all instances of all pairs coming from the mapper arrive at the reducer?
2. Are the calculations correct?

In order to do this, typically we would need to set up a smaller sample data set
and manually verify the answers to all the above question. Alternatively, we
can also leverage Linux's capabilities to customize our mapping pipeline.

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat /repository/movielens/ratings.csv 2>/dev/null | head -n 1000 | python mapper03.py | grep Matrix
~~~

~~~ {.output}
Matrix, The (1999)	3.5
Matrix, The (1999)	4.0
Matrix, The (1999)	2.5
Matrix, The (1999)	4.5
Matrix, The (1999)	2.0
~~~

The above adjusted command lists five possible instances of review for
**The Matrix**. We also modify the reducer to include the values of
**current_rating_sum** and **current_rating_count** in the output report:
~~~ {.bash}
print ("%s\t%s\t%s\t%s" % (current_movie, rating_average, current_rating_sum, current_rating_count))
~~~

Testing this output against the reducer, we observe that our reducer's
operations are correct.

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat /repository/movielens/ratings.csv 2>/dev/null | head -n 1000 | python mapper03.py | grep Matrix | sort | python reducer01.py
~~~

~~~ {.output}
Matrix, The (1999)	3.3	16.5	5
~~~

## Check your understanding: Map genres to ratings {.challenge}
While the reducer code uses variables such as movie and current_movie, in
principle, this reducer can take any set of KEY/GROUP OF VALUES and calculate
the average value of this KEY. Use this reducer together with **mapGenre.py** to
test the finding of rating averages of movie genres.
