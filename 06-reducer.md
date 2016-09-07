
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


```python
!ssh dsciu001 hdfs dfs -cat /user/lngo/intro-to-hadoop/ml-10M100K/ratings.dat 2>/dev/null \
    | head -n 10 \
    | python /home/lngo/intro-to-hadoop/mapper02.py \
    | sort \
    | python /home/lngo/intro-to-hadoop/reducer01.py
```

    Boomerang (1992)	5.0
    Dumb & Dumber (1994)	5.0
    Flintstones, The (1994)	5.0
    Forrest Gump (1994)	5.0
    Jungle Book, The (1994)	5.0
    Lion King, The (1994)	5.0
    Net, The (1995)	5.0
    Outbreak (1995)	5.0
    Stargate (1994)	5.0
    Star Trek: Generations (1994)	5.0


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


```python
!ssh dsciu001 hdfs dfs -cat /user/lngo/intro-to-hadoop/ml-10M100K/ratings.dat 2>/dev/null \
    | head -n 2000 | python /home/lngo/intro-to-hadoop/mapper02.py | grep Matrix
```

    Matrix, The (1999)	5.0
    Matrix, The (1999)	5.0
    Matrix Reloaded, The (2003)	4.0
    Matrix Revolutions, The (2003)	4.0
    Matrix, The (1999)	5.0
    Matrix, The (1999)	1.0


The above adjusted command lists five possible instances of review for
**The Matrix**. We also modify the reducer to include the values of
**current_rating_sum** and **current_rating_count** in the output report:
~~~ {.bash}
print ("%s\t%s\t%s\t%s" % (current_movie, rating_average, current_rating_sum, current_rating_count))
~~~

Testing this output against the reducer, we observe that our reducer's
operations are correct.


```python
!ssh dsciu001 hdfs dfs -cat /user/lngo/intro-to-hadoop/ml-10M100K/ratings.dat 2>/dev/null \
    | head -n 2000 | python /home/lngo/intro-to-hadoop/mapper02.py \
    | grep Matrix | sort \
    | python /home/lngo/intro-to-hadoop/reducer02.py
```

    Matrix Reloaded, The (2003)	4.0	4.0	1
    Matrix Revolutions, The (2003)	4.0	4.0	1
    Matrix, The (1999)	4.0	16.0	4


## Check your understanding: Map genres to ratings {.challenge}
While the reducer code uses variables such as movie and current_movie, in
principle, this reducer can take any set of KEY/GROUP OF VALUES and calculate
the average value of this KEY. Use this reducer together with **mapGenre.py** to
test the finding of rating averages of movie genres.
