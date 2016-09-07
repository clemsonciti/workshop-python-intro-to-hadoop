
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


```python
!ssh dsciu001 yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar \
    -input intro-to-hadoop/gutenberg-shakespeare.txt  \
    -output intro-to-hadoop/wc -mapper cat -reducer "wc"
```

    packageJobJar: [] [/usr/hdp/2.4.2.0-258/hadoop-mapreduce/hadoop-streaming-2.7.1.2.4.2.0-258.jar] /var/lib/ambari-agent/tmp/hadoop_java_io_tmpdir/streamjob3414726412006351394.jar tmpDir=null
    16/07/25 13:01:43 INFO impl.TimelineClientImpl: Timeline service address: http://dscim003.palmetto.clemson.edu:8188/ws/v1/timeline/
    16/07/25 13:01:44 INFO impl.TimelineClientImpl: Timeline service address: http://dscim003.palmetto.clemson.edu:8188/ws/v1/timeline/
    16/07/25 13:01:44 INFO hdfs.DFSClient: Created HDFS_DELEGATION_TOKEN token 857 for lngo on ha-hdfs:dsci
    16/07/25 13:01:44 INFO security.TokenCache: Got dt for hdfs://dsci; Kind: HDFS_DELEGATION_TOKEN, Service: ha-hdfs:dsci, Ident: (HDFS_DELEGATION_TOKEN token 857 for lngo)
    16/07/25 13:01:44 INFO mapred.FileInputFormat: Total input paths to process : 1
    16/07/25 13:01:45 INFO mapreduce.JobSubmitter: number of splits:2
    16/07/25 13:01:45 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1469462752582_0008
    16/07/25 13:01:45 INFO mapreduce.JobSubmitter: Kind: HDFS_DELEGATION_TOKEN, Service: ha-hdfs:dsci, Ident: (HDFS_DELEGATION_TOKEN token 857 for lngo)
    16/07/25 13:01:45 INFO impl.YarnClientImpl: Submitted application application_1469462752582_0008
    16/07/25 13:01:45 INFO mapreduce.Job: The url to track the job: http://dscim001.palmetto.clemson.edu:8088/proxy/application_1469462752582_0008/
    16/07/25 13:01:45 INFO mapreduce.Job: Running job: job_1469462752582_0008
    16/07/25 13:02:01 INFO mapreduce.Job: Job job_1469462752582_0008 running in uber mode : false
    16/07/25 13:02:01 INFO mapreduce.Job:  map 0% reduce 0%
    16/07/25 13:02:18 INFO mapreduce.Job:  map 50% reduce 0%
    16/07/25 13:02:20 INFO mapreduce.Job:  map 100% reduce 0%
    16/07/25 13:02:31 INFO mapreduce.Job:  map 100% reduce 100%
    16/07/25 13:02:31 INFO mapreduce.Job: Job job_1469462752582_0008 completed successfully
    16/07/25 13:02:31 INFO mapreduce.Job: Counters: 49
    	File System Counters
    		FILE: Number of bytes read=5820389
    		FILE: Number of bytes written=12081444
    		FILE: Number of read operations=0
    		FILE: Number of large read operations=0
    		FILE: Number of write operations=0
    		HDFS: Number of bytes read=5476614
    		HDFS: Number of bytes written=25
    		HDFS: Number of read operations=9
    		HDFS: Number of large read operations=0
    		HDFS: Number of write operations=2
    	Job Counters 
    		Launched map tasks=2
    		Launched reduce tasks=1
    		Rack-local map tasks=2
    		Total time spent by all maps in occupied slots (ms)=30741
    		Total time spent by all reduces in occupied slots (ms)=22468
    		Total time spent by all map tasks (ms)=30741
    		Total time spent by all reduce tasks (ms)=11234
    		Total vcore-seconds taken by all map tasks=30741
    		Total vcore-seconds taken by all reduce tasks=11234
    		Total megabyte-seconds taken by all map tasks=251830272
    		Total megabyte-seconds taken by all reduce tasks=184057856
    	Map-Reduce Framework
    		Map input records=124213
    		Map output records=124213
    		Map output bytes=5571957
    		Map output materialized bytes=5820395
    		Input split bytes=230
    		Combine input records=0
    		Combine output records=0
    		Reduce input groups=111202
    		Reduce shuffle bytes=5820395
    		Reduce input records=124213
    		Reduce output records=1
    		Spilled Records=248426
    		Shuffled Maps =2
    		Failed Shuffles=0
    		Merged Map outputs=2
    		GC time elapsed (ms)=728
    		CPU time spent (ms)=22740
    		Physical memory (bytes) snapshot=2323980288
    		Virtual memory (bytes) snapshot=34513907712
    		Total committed heap usage (bytes)=2091384832
    	Shuffle Errors
    		BAD_ID=0
    		CONNECTION=0
    		IO_ERROR=0
    		WRONG_LENGTH=0
    		WRONG_MAP=0
    		WRONG_REDUCE=0
    	File Input Format Counters 
    		Bytes Read=5476384
    	File Output Format Counters 
    		Bytes Written=25
    16/07/25 13:02:31 INFO streaming.StreamJob: Output directory: intro-to-hadoop/wc



```python
!ssh dsciu001 hdfs dfs -ls intro-to-hadoop/wc
```

    Java HotSpot(TM) 64-Bit Server VM warning: ignoring option MaxPermSize=512m; support was removed in 8.0
    Found 2 items
    -rw-r--r--   2 lngo hdfs          0 2016-07-25 13:02 intro-to-hadoop/wc/_SUCCESS
    -rw-r--r--   2 lngo hdfs         25 2016-07-25 13:02 intro-to-hadoop/wc/part-00000



```python
!ssh dsciu001 hdfs dfs -cat intro-to-hadoop/wc/part-00000
```

    Java HotSpot(TM) 64-Bit Server VM warning: ignoring option MaxPermSize=512m; support was removed in 8.0
     124213  899681 5571957	


Several items need to be paid attention to in the above example. First, the
location of the input and output directories are relative. That is, without an
initial backslash (**/**), YARN assumes that the path starts from inside user's
home directory on HDFS, which is **/user/user-name**. Second, the output
directory must not exist prior to the *yarn jar* call, otherwise, the command
will fail with an *output directory already exists* error.  
