---
layout: page
title: Introduction to Hadoop
subtitle: Integrating Python Mapper and Reducer in Hadoop
minutes: 15
---
> ## Learning Objectives {.objectives}
>
> *   Run the combination of Python-based mapper and reducer on the Hadoop
>     infrastructure
> *   Customize reducer for questions that require global access to KEYS

With the mapper and reducer created and tested, the final step is to run this
combination on the Hadoop infrastructure.

~~~ {.bash}
!ssh dsciu001 yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar -input /repository/movielens/ratings.csv  -output ratings -file /home/<username>/mapreduce/mapper03.py -mapper mapper03.py -file /home/<username>/mapreduce/mapper03.py -reducer reducer01.py -file /home/<username>/mapreduce/movies.csv
~~~

~~~ {.output}
16/07/06 12:30:13 WARN streaming.StreamJob: -file option is deprecated, please use generic option -files instead.
packageJobJar: [/home/lngo/mapreduce/mapper03.py, /home/lngo/mapreduce/reducer01.py, /home/lngo/mapreduce/movies.csv] [/usr/hdp/2.4.2.0-258/hadoop-mapreduce/hadoop-streaming-2.7.1.2.4.2.0-258.jar] /var/lib/ambari-agent/tmp/hadoop_java_io_tmpdir/streamjob1141304963588025269.jar tmpDir=null
16/07/06 12:30:15 INFO impl.TimelineClientImpl: Timeline service address: http://dscim003.palmetto.clemson.edu:8188/ws/v1/timeline/
16/07/06 12:30:15 INFO impl.TimelineClientImpl: Timeline service address: http://dscim003.palmetto.clemson.edu:8188/ws/v1/timeline/
16/07/06 12:30:16 INFO mapred.FileInputFormat: Total input paths to process : 1
16/07/06 12:30:16 INFO mapreduce.JobSubmitter: number of splits:5
16/07/06 12:30:16 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1467819539655_0009
16/07/06 12:30:16 INFO impl.YarnClientImpl: Submitted application application_1467819539655_0009
16/07/06 12:30:17 INFO mapreduce.Job: The url to track the job: http://dscim001.palmetto.clemson.edu:8088/proxy/application_1467819539655_0009/
16/07/06 12:30:17 INFO mapreduce.Job: Running job: job_1467819539655_0009
16/07/06 12:30:26 INFO mapreduce.Job: Job job_1467819539655_0009 running in uber mode : false
16/07/06 12:30:26 INFO mapreduce.Job:  map 0% reduce 0%
16/07/06 12:30:39 INFO mapreduce.Job:  map 3% reduce 0%
16/07/06 12:30:40 INFO mapreduce.Job:  map 5% reduce 0%
16/07/06 12:30:42 INFO mapreduce.Job:  map 8% reduce 0%
16/07/06 12:30:43 INFO mapreduce.Job:  map 10% reduce 0%
16/07/06 12:30:45 INFO mapreduce.Job:  map 11% reduce 0%
16/07/06 12:30:46 INFO mapreduce.Job:  map 14% reduce 0%
16/07/06 12:30:48 INFO mapreduce.Job:  map 15% reduce 0%
16/07/06 12:30:49 INFO mapreduce.Job:  map 20% reduce 0%
16/07/06 12:30:51 INFO mapreduce.Job:  map 21% reduce 0%
16/07/06 12:30:52 INFO mapreduce.Job:  map 25% reduce 0%
16/07/06 12:30:55 INFO mapreduce.Job:  map 30% reduce 0%
16/07/06 12:30:58 INFO mapreduce.Job:  map 35% reduce 0%
16/07/06 12:31:01 INFO mapreduce.Job:  map 39% reduce 0%
16/07/06 12:31:02 INFO mapreduce.Job:  map 40% reduce 0%
16/07/06 12:31:04 INFO mapreduce.Job:  map 44% reduce 0%
16/07/06 12:31:05 INFO mapreduce.Job:  map 46% reduce 0%
16/07/06 12:31:07 INFO mapreduce.Job:  map 48% reduce 0%
16/07/06 12:31:08 INFO mapreduce.Job:  map 50% reduce 0%
16/07/06 12:31:10 INFO mapreduce.Job:  map 51% reduce 0%
16/07/06 12:31:11 INFO mapreduce.Job:  map 54% reduce 0%
16/07/06 12:31:13 INFO mapreduce.Job:  map 55% reduce 0%
16/07/06 12:31:14 INFO mapreduce.Job:  map 58% reduce 0%
16/07/06 12:31:16 INFO mapreduce.Job:  map 65% reduce 0%
16/07/06 12:31:17 INFO mapreduce.Job:  map 67% reduce 0%
16/07/06 12:31:20 INFO mapreduce.Job:  map 70% reduce 0%
16/07/06 12:31:23 INFO mapreduce.Job:  map 72% reduce 0%
16/07/06 12:31:26 INFO mapreduce.Job:  map 73% reduce 0%
16/07/06 12:31:29 INFO mapreduce.Job:  map 73% reduce 7%
16/07/06 12:31:32 INFO mapreduce.Job:  map 80% reduce 7%
16/07/06 12:31:35 INFO mapreduce.Job:  map 87% reduce 13%
16/07/06 12:31:38 INFO mapreduce.Job:  map 87% reduce 20%
16/07/06 12:31:39 INFO mapreduce.Job:  map 100% reduce 20%
16/07/06 12:31:41 INFO mapreduce.Job:  map 100% reduce 35%
16/07/06 12:31:44 INFO mapreduce.Job:  map 100% reduce 41%
16/07/06 12:31:48 INFO mapreduce.Job:  map 100% reduce 45%
16/07/06 12:31:51 INFO mapreduce.Job:  map 100% reduce 49%
16/07/06 12:31:54 INFO mapreduce.Job:  map 100% reduce 54%
16/07/06 12:31:57 INFO mapreduce.Job:  map 100% reduce 58%
16/07/06 12:32:00 INFO mapreduce.Job:  map 100% reduce 62%
16/07/06 12:32:03 INFO mapreduce.Job:  map 100% reduce 67%
16/07/06 12:32:06 INFO mapreduce.Job:  map 100% reduce 68%
16/07/06 12:32:10 INFO mapreduce.Job:  map 100% reduce 70%
16/07/06 12:32:13 INFO mapreduce.Job:  map 100% reduce 71%
16/07/06 12:32:16 INFO mapreduce.Job:  map 100% reduce 73%
16/07/06 12:32:19 INFO mapreduce.Job:  map 100% reduce 74%
16/07/06 12:32:22 INFO mapreduce.Job:  map 100% reduce 76%
16/07/06 12:32:25 INFO mapreduce.Job:  map 100% reduce 77%
16/07/06 12:32:28 INFO mapreduce.Job:  map 100% reduce 79%
16/07/06 12:32:31 INFO mapreduce.Job:  map 100% reduce 80%
16/07/06 12:32:35 INFO mapreduce.Job:  map 100% reduce 82%
16/07/06 12:32:38 INFO mapreduce.Job:  map 100% reduce 84%
16/07/06 12:32:42 INFO mapreduce.Job:  map 100% reduce 85%
16/07/06 12:32:45 INFO mapreduce.Job:  map 100% reduce 87%
16/07/06 12:32:48 INFO mapreduce.Job:  map 100% reduce 89%
16/07/06 12:32:51 INFO mapreduce.Job:  map 100% reduce 90%
16/07/06 12:32:54 INFO mapreduce.Job:  map 100% reduce 92%
16/07/06 12:32:57 INFO mapreduce.Job:  map 100% reduce 93%
16/07/06 12:33:00 INFO mapreduce.Job:  map 100% reduce 95%
16/07/06 12:33:03 INFO mapreduce.Job:  map 100% reduce 96%
16/07/06 12:33:06 INFO mapreduce.Job:  map 100% reduce 98%
16/07/06 12:33:09 INFO mapreduce.Job:  map 100% reduce 99%
16/07/06 12:33:13 INFO mapreduce.Job:  map 100% reduce 100%
16/07/06 12:33:14 INFO mapreduce.Job: Job job_1467819539655_0009 completed successfully
16/07/06 12:33:14 INFO mapreduce.Job: Counters: 50
	File System Counters
		FILE: Number of bytes read=729355490
		FILE: Number of bytes written=1459573425
		FILE: Number of read operations=0
		FILE: Number of large read operations=0
		FILE: Number of write operations=0
		HDFS: Number of bytes read=620729398
		HDFS: Number of bytes written=1546431
		HDFS: Number of read operations=18
		HDFS: Number of large read operations=0
		HDFS: Number of write operations=2
	Job Counters
		Launched map tasks=5
		Launched reduce tasks=1
		Data-local map tasks=1
		Rack-local map tasks=4
		Total time spent by all maps in occupied slots (ms)=323066
		Total time spent by all reduces in occupied slots (ms)=228592
		Total time spent by all map tasks (ms)=323066
		Total time spent by all reduce tasks (ms)=114296
		Total vcore-seconds taken by all map tasks=323066
		Total vcore-seconds taken by all reduce tasks=114296
		Total megabyte-seconds taken by all map tasks=2646556672
		Total megabyte-seconds taken by all reduce tasks=1872625664
	Map-Reduce Framework
		Map input records=22884378
		Map output records=22884377
		Map output bytes=683586345
		Map output materialized bytes=729355514
		Input split bytes=480
		Combine input records=0
		Combine output records=0
		Reduce input groups=33647
		Reduce shuffle bytes=729355514
		Reduce input records=22884377
		Reduce output records=33647
		Spilled Records=45768754
		Shuffled Maps =5
		Failed Shuffles=0
		Merged Map outputs=5
		GC time elapsed (ms)=3993
		CPU time spent (ms)=553480
		Physical memory (bytes) snapshot=14627205120
		Virtual memory (bytes) snapshot=61926924288
		Total committed heap usage (bytes)=16984834048
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	File Input Format Counters
		Bytes Read=620728918
	File Output Format Counters
		Bytes Written=1546431
16/07/06 12:33:14 INFO streaming.StreamJob: Output directory: ratings
~~~

The content of the ratings directory includes an empty file serves as a flag to
indicate whether the operation was successful or not, and the output files. The
number of output files depends on how many reducers we use.

~~~ {.bash}
!ssh dsciu001 hdfs dfs -ls ratings 2>/dev/null
~~~

~~~ {.output}
Found 2 items
-rw-r--r--   2 lngo hdfs          0 2016-07-06 12:33 ratings/_SUCCESS
-rw-r--r--   2 lngo hdfs    1546431 2016-07-06 12:33 ratings/part-00000
~~~

We can **cat** for the content of the output file

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat ratings/part-00000 2>/dev/null | head
~~~

~~~ {.output}
"Great Performances" Cats (1998)	2.77536231884	574.5	207
#1 Cheerleader Camp (2010)	2.5	12.5	5
#chicagoGirl: The Social Network Takes on a Dictator (2013)	3.66666666667	11.0	3
$ (Dollars) (1971)	2.74074074074	74.0	27
$5 a Day (2008)	2.98	149.0	50
$9.99 (2008)	3.15873015873	199.0	63
$ellebrity (Sellebrity) (2012)	2.25	13.5	6
'49-'17 (1917)	2.5	2.5	1
'71 (2014)	3.64705882353	496.0	136
'Hellboy': The Seeds of Creation (2004)	3.08878504673	330.5	107
~~~

It is also possible to increase number of reducers

~~~ {.bash}
!ssh dsciu001 yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar -D mapreduce.job.reduces=4 -input /repository/movielens/ratings.csv  -output ratings3 -file /home/lngo/mapreduce/mapper03.py -mapper /home/lngo/mapreduce/mapper03.py -file /home/lngo/mapreduce/reducer01.py -reducer /home/lngo/mapreduce/reducer01.py -file /home/lngo/mapreduce/movies.csv
~~~

~~~ {.bash}
!ssh dsciu001 hdfs dfs -ls ratings3 2>/dev/null
~~~

~~~ {.output}
Found 5 items
-rw-r--r--   2 lngo hdfs          0 2016-07-06 23:22 ratings3/_SUCCESS
-rw-r--r--   2 lngo hdfs     392511 2016-07-06 23:22 ratings3/part-00000
-rw-r--r--   2 lngo hdfs     384436 2016-07-06 23:21 ratings3/part-00001
-rw-r--r--   2 lngo hdfs     383097 2016-07-06 23:22 ratings3/part-00002
-rw-r--r--   2 lngo hdfs     386387 2016-07-06 23:21 ratings3/part-00003
~~~

Aside from performance implication, an important difference between using one
and many reducers is demonstrated in cases where we want to perform operations
that require a global examination of the data. Let's say the movie company
wishes to identify the movie with highest rating average.

Create a file called reduce02.py with the following content

~~~ {.output}
#!/usr/bin/env python
import sys

current_movie = None
current_rating_sum = 0
current_rating_count = 0

max_movie = ""
max_average = 0

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
      if rating_average > max_average:
        max_movie = current_movie
        max_average = rating_average
    current_movie = movie
    current_rating_sum = rating
    current_rating_count = 1

if current_movie == movie:
  rating_average = current_rating_sum / current_rating_count
  if rating_average > max_average:
    max_movie = current_movie
    max_average = rating_average

print ("%s\t%s" % (max_movie, max_average))
~~~

Rerun the Hadoop program using one and four reducers, respectively:

~~~ {.bash}
!ssh dsciu001 yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar -input /repository/movielens/ratings.csv  -output maxRating -file /home/lngo/mapreduce/mapper03.py -mapper /home/lngo/mapreduce/mapper03.py -file /home/lngo/mapreduce/reducer02.py -reducer /home/lngo/mapreduce/reducer02.py -file /home/lngo/mapreduce/movies.csv
~~~

~~~ {.bash}
!ssh dsciu001 yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar -D mapreduce.job.reduces=4 -input /repository/movielens/ratings.csv  -output maxRating4R -file /home/lngo/mapreduce/mapper03.py -mapper /home/lngo/mapreduce/mapper03.py -file /home/lngo/mapreduce/reducer02.py -reducer /home/lngo/mapreduce/reducer02.py -file /home/lngo/mapreduce/movies.csv
~~~

In the case of one reducer, there is only a single answer for the movie with
highest rating average. With four reducers, we have four possible answers. On
the other hand, it is quite feasible to infer the final single answer from a
set of four possible choices.

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat maxRating/part-00000 2>/dev/null
~~~

~~~ {.output}
A Job to Kill For (2006)	5.0
~~~

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat maxRating4R/part-00000 2>/dev/null
~~~

~~~ {.output}
A Job to Kill For (2006)	5.0
~~~

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat maxRating4R/part-00001 2>/dev/null
~~~

~~~ {.output}
10 Attitudes (2001)	5.0
~~~

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat maxRating4R/part-00002 2>/dev/null
~~~

~~~ {.output}
A Gentle Spirit (1987)	5.0
~~~

~~~ {.bash}
!ssh dsciu001 hdfs dfs -cat maxRating4R/part-00003 2>/dev/null
~~~

~~~ {.output}
2 (2007)	5.0
~~~


## Check your understanding: Additional conditions on the reduce side {.challenge}
The previous results do not make sense intuitively, as these movies are not
well known. It is possible that our results are skewed by movies having too
few reviews. Modify the reducer so that we only consider movies that have more
than one thousand ratings totally. Name this reducer reducer03.py. Run the
Hadoop MapReduce program again with mapper03.py and reducer03.py using one and
four reducers respectively. Report the outcome.



## Check your understanding: User Study {.challenge}
User feedback plays an important role in marketing strategies. Implement a
Hadoop MapReduce program that identifies the user that rates the most movies
over time. Identify the genre that this user rates most favorably.
