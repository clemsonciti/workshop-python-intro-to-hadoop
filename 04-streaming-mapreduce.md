---
layout: page
title: Introduction to Hadoop
subtitle: Streaming MapReduce
minutes: 10
---
> ## Learning Objectives {.objectives}
>
> *   Understand how to run Hadoop MapReduce programs
> *   Create Hadoop MapReduce commands to run external programs as
>     mappers and reducers

Any Application-related interactions between users, the Hadoop MapReduce
framework, and HDFS are done though YARN, Hadoop' default resource manager. The
most common interactions include submitting applications to YARN and inquiring
about the status of the applications. The generic syntax is:

    yarn COMMAND --loglevel loglevel [generic_options] [command_options]

Starting from the least to the most verbose, we have FATAL, ERROR, WARN, INFO,
DEBUG, and TRACE. Default level is INFO.

generic_options | Description |
----------------|-------------|
`-archives <comma separated list of archives>` | Specify archives to be unarchived on the compute machines. Applies only to job |
`-conf <configuration file>` | Specify an application configuration file |
`-D <property>=<value>` | Use value for a given property |
`-files <comma separated list of files>` | Specify files to be copied to the cluster. Applies only to job |
`-jt <local> or <resourcemanager:port>` | Specify a ResourceManager. Applies only to job |
`-libjars <comma separated list of jars>` | Specify the jar files to include in the classpath. Applies only to job.

#### COMMAND: jar
Run a jar file as an application on Cypress. Usage:

    yarn jar <jar file> [mainClass] args ...

Typically, YARN applications are written in Java and bundled into jar files to be executed. However, Hadoop also supports the execution of non-Java applications via the Hadoop Streaming utility. This utility allows you to use any executable or scripts as the mapper and/or the reducer for a YARN application. Usage:

    yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar [generic_options] [streaming_options]

streaming_options | Optional/Required | Description |
------------------|-------------------|-------------|
`-input directoryname or filename` | Required | Input location for mapper |
`-output directoryname` | Required | Output location for reducer |

`-mapper executable or JavaClassName` | Required | Mapper executable |
`-reducer executable or JavaClassName` | Required | Reducer executable |
`-file filename` | Optional |  Make the mapper, reducer, or combiner executable available locally on the compute nodes |
`-inputformat JavaClassName` | Optional | Class you supply should return key/value pairs of Text class. If not specified, TextInputFormat is used as the default |
`-outputformat JavaClassName` | Optional | Class you supply should take key/value pairs of Text class. If not specified, TextOutputformat is used as the default |
`-partitioner JavaClassName` | Optional | Class that determines which reduce a key is sent to |
`-combiner executable or JavaClassName` | Optional | Combiner executable for map output |
`-cmdenv name=value` | Optional | Pass environment variable to streaming commands |
`-inputreader JavaClassName` | Optional | For backwards-compatibility: specifies a record reader class (instead of an input format class) |
`-verbose` | Optional | Verbose output |
`-lazyOutput` | Optional | Create output lazily. For example, if the output format is based on FileOutputFormat, the output file is created only on the first call to Context.write |
`-numReduceTasks` | Optional | Specify the number of reducers |
`-mapdebug` | Optional | Script to call when map task fails |
`-reducedebug` | Optional | Script to call when reduce task fails |

To demonstrate Hadoop Streaming functionality, let's look at the problem of
counting how many instances of "thou" there are in Gutenberg's complete work of
Shakespeare.

~~~{.bash}
!ssh dsciu001 yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar -input intro-to-hadoop/gutenberg-shakespeare.txt  -output thou-count -mapper "grep -e thou" -reducer "wc -w"
~~~

~~~ {.output}
...
2016-06-29 14:37:14,692 INFO  [main] mapreduce.Job (Job.java:monitorAndPrintJob(1356)) - Job job_1466735278048_0010 completed successfully
2016-06-29 14:37:14,818 INFO  [main] mapreduce.Job (Job.java:monitorAndPrintJob(1363)) - Counters: 43
	File System Counters
		FILE: Number of bytes read=335881
		FILE: Number of bytes written=920423
		FILE: Number of read operations=0
		FILE: Number of large read operations=0
		FILE: Number of write operations=0
		HDFS: Number of bytes read=5678917
		HDFS: Number of bytes written=7
		HDFS: Number of read operations=9
		HDFS: Number of large read operations=0
		HDFS: Number of write operations=2
	Job Counters
		Launched map tasks=2
		Launched reduce tasks=1
		Data-local map tasks=2
		Total time spent by all maps in occupied slots (ms)=173408
		Total time spent by all reduces in occupied slots (ms)=43664
	Map-Reduce Framework
		Map input records=124796
		Map output records=6051
		Map output bytes=323773
		Map output materialized bytes=335887
		Input split bytes=236
		Combine input records=0
		Combine output records=0
		Reduce input groups=6049
		Reduce shuffle bytes=335887
		Reduce input records=6051
		Reduce output records=1
		Spilled Records=12102
		Shuffled Maps =2
		Failed Shuffles=0
		Merged Map outputs=2
		GC time elapsed (ms)=312
		CPU time spent (ms)=5150
		Physical memory (bytes) snapshot=1229393920
		Virtual memory (bytes) snapshot=3850330112
		Total committed heap usage (bytes)=1543569408
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	File Input Format Counters
		Bytes Read=5678681
	File Output Format Counters
		Bytes Written=7
2016-06-29 14:37:14,819 INFO  [main] streaming.StreamJob (StreamJob.java:submitAndMonitorJob(1022)) - Output directory: thou-count
~~~

Several items need to be paid attention to in the above example. First, the
location of the input and output directories are relative. That is, without an
initial backslash (**/**), YARN assumes that the path starts from inside user's
home directory on HDFS, which is **/user/user-name**. Second, the output
directory must not exist prior to the *yarn jar* call, otherwise, the command
will fail with an *output directory already exists* error.  
