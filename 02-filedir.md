---
layout: page
title: Introduction to Hadoop
subtitle: Understanding HDFS Files and Directories
minutes: 10
---
> ## Learning Objectives {.objectives}
>
> *   Understand how files and directories in HDFS are viewed
>     relative to files and directories in the Linux file systems.

More than just a file storage and management system, HDFS provides an
infrastructure through which parallel processing of massive amount of data is
enabled.

<img src="fig/HDFSBlockView.png" \
     alt="HDFSBlockView" \
     style="height:500px">

To enable large scale processing of big data, Hadoop takes a straight forward
approach in HDFS, which is to simply divide a very large data file into
smaller blocks and distribute these blocks across a cluster of computers
(the Hadoop cluster). The blocks are replicated to ensure that if any
individual computer fails, there are still enough copies of the data on the
remaining computers for uninterrupted operations.

Checking block status of file **ratings.csv**:
~~~ {.bash}
!ssh dsciu001 hdfs fsck /repository/movielens/ratings.csv -files -blocks -locations
~~~

~~~ {.output}
Java HotSpot(TM) 64-Bit Server VM warning: ignoring option MaxPermSize=512m; support was removed in 8.0
Connecting to namenode via http://dscim003.palmetto.clemson.edu:50070/fsck?ugi=lngo&files=1&blocks=1&locations=1&path=%2Frepository%2Fmovielens%2Fratings.csv
FSCK started by lngo (auth:KERBEROS_SSL) from /10.125.8.212 for path /repository/movielens/ratings.csv at Fri Jun 10 15:02:46 EDT 2016
/repository/movielens/ratings.csv 620204630 bytes, 5 block(s):  OK
0. BP-1143747467-10.125.40.142-1413584797204:blk_1092781164_19049924 len=134217728 repl=2 [DatanodeInfoWithStorage[10.125.8.210:1019,DS-c63a14c3-6b98-4b42-99fd-a92d24649780,DISK], DatanodeInfoWithStorage[10.125.8.206:1019,DS-e9f1d755-1c58-4b64-83ef-5250558887c9,DISK]]
1. BP-1143747467-10.125.40.142-1413584797204:blk_1092781165_19049925 len=134217728 repl=2 [DatanodeInfoWithStorage[10.125.8.201:1019,DS-b02b6b9e-3df0-4538-ad29-7cc670c91b7e,DISK], DatanodeInfoWithStorage[10.125.8.197:1019,DS-dae73583-7060-4048-815d-784503d5733b,DISK]]
2. BP-1143747467-10.125.40.142-1413584797204:blk_1092781166_19049926 len=134217728 repl=2 [DatanodeInfoWithStorage[10.125.8.210:1019,DS-85a0c824-55dc-4f42-b59f-ba27c6ee7629,DISK], DatanodeInfoWithStorage[10.125.8.201:1019,DS-1e7b23ef-3f7e-42b4-a4e5-28c47430ff8d,DISK]]
3. BP-1143747467-10.125.40.142-1413584797204:blk_1092781167_19049927 len=134217728 repl=2 [DatanodeInfoWithStorage[10.125.8.199:1019,DS-479822cd-7746-4bfd-bc1a-f695bf9c30e3,DISK], DatanodeInfoWithStorage[10.125.8.196:1019,DS-6b5ffb1d-eb6b-4a39-a01f-fcf511268635,DISK]]
4. BP-1143747467-10.125.40.142-1413584797204:blk_1092781168_19049928 len=83333718 repl=2 [DatanodeInfoWithStorage[10.125.8.204:1019,DS-f5b20974-dc6d-49ab-808a-561f7cbb327b,DISK], DatanodeInfoWithStorage[10.125.8.206:1019,DS-28b880df-87df-4cc5-ae47-ad973ebc70d4,DISK]]

Status: HEALTHY
 Total size:	620204630 B
 Total dirs:	0
 Total files:	1
 Total symlinks:		0
 Total blocks (validated):	5 (avg. block size 124040926 B)
 Minimally replicated blocks:	5 (100.0 %)
 Over-replicated blocks:	0 (0.0 %)
 Under-replicated blocks:	0 (0.0 %)
 Mis-replicated blocks:		0 (0.0 %)
 Default replication factor:	2
 Average block replication:	2.0
 Corrupt blocks:		0
 Missing replicas:		0 (0.0 %)
 Number of data-nodes:		16
 Number of racks:		1
FSCK ended at Fri Jun 10 15:02:46 EDT 2016 in 2 milliseconds


The filesystem under path '/repository/movielens/ratings.csv' is HEALTHY

~~~

To bring out the nature of data locality in this distributed block-based
approach, it is critical to minimize the needs for data transfer between
computers storing these data blocks. A programming approach called
***mapreduce*** is leveraged by Google to make this happen.


> ## mapreduce vs Apache MapReduce {.callout}
>
> It is important to distinguish between the mapreduce programming
> paradigm and the Apache MapReduce implementation. The mapreduce programming
> paradigm includes any implementation approach that ***maps*** the same
> operation to individual data elements of a data collection, and then
> ***reduce*** the resulting data to a final simplified result. For example,
> Apache Spark, the highly touted "MapReduce killer", utilizes in-memory
> operations to implement its mapping and reducing capabilities. Apache
> MapReduce is the defult implementation of the mapreduce
> paradigm for Hadoop.
