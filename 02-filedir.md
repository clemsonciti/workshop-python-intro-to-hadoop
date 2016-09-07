
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
    


```python
!ssh dsciu001 hdfs fsck /user/lngo/intro-to-hadoop -files -blocks -locations
```

    Java HotSpot(TM) 64-Bit Server VM warning: ignoring option MaxPermSize=512m; support was removed in 8.0
    Connecting to namenode via http://dscim002.palmetto.clemson.edu:50070/fsck?ugi=lngo&files=1&blocks=1&locations=1&path=%2Fuser%2Flngo%2Fintro-to-hadoop
    FSCK started by lngo (auth:KERBEROS_SSL) from /10.125.8.212 for path /user/lngo/intro-to-hadoop at Fri Jul 22 15:04:10 EDT 2016
    /user/lngo/intro-to-hadoop <dir>
    /user/lngo/intro-to-hadoop/gutenberg-shakespeare.txt 5447744 bytes, 1 block(s):  OK
    0. BP-1143747467-10.125.40.142-1413584797204:blk_1099953286_26224275 len=5447744 repl=2 [DatanodeInfoWithStorage[10.125.8.197:1019,DS-9d2f85fa-af96-41a0-9a7a-362e07fb0721,DISK], DatanodeInfoWithStorage[10.125.8.196:1019,DS-af361ac7-1213-46f8-8147-2c1356a2315e,DISK]]
    
    /user/lngo/intro-to-hadoop/ml-10M100K <dir>
    /user/lngo/intro-to-hadoop/ml-10M100K/README.html 11563 bytes, 1 block(s):  OK
    0. BP-1143747467-10.125.40.142-1413584797204:blk_1099955769_26226793 len=11563 repl=2 [DatanodeInfoWithStorage[10.125.8.206:1019,DS-acc010e2-e3c6-48ae-88f4-48e48e071dfa,DISK], DatanodeInfoWithStorage[10.125.8.224:1019,DS-bd7d954b-7eb8-47d6-8d4d-172ea3d31c0a,DISK]]
    
    /user/lngo/intro-to-hadoop/ml-10M100K/allbut.pl 753 bytes, 1 block(s):  OK
    0. BP-1143747467-10.125.40.142-1413584797204:blk_1099955770_26226794 len=753 repl=2 [DatanodeInfoWithStorage[10.125.8.200:1019,DS-83adebbd-087a-416f-970b-0ed5df8ac018,DISK], DatanodeInfoWithStorage[10.125.8.236:1019,DS-7e9ddb9d-efb1-4443-85d2-9a5dd70334c6,DISK]]
    
    /user/lngo/intro-to-hadoop/ml-10M100K/movies.dat 522197 bytes, 1 block(s):  OK
    0. BP-1143747467-10.125.40.142-1413584797204:blk_1099955771_26226795 len=522197 repl=2 [DatanodeInfoWithStorage[10.125.8.229:1019,DS-c1bf0fdf-f493-4125-a4fa-01ca9eaac99c,DISK], DatanodeInfoWithStorage[10.125.8.221:1019,DS-b2994f91-79e1-4ddb-827a-44cc6fb1b4de,DISK]]
    
    /user/lngo/intro-to-hadoop/ml-10M100K/ratings.dat 265105635 bytes, 2 block(s):  OK
    0. BP-1143747467-10.125.40.142-1413584797204:blk_1099955772_26226796 len=134217728 repl=2 [DatanodeInfoWithStorage[10.125.8.204:1019,DS-81cf1971-dc09-4cdf-a088-6229c11d0e0c,DISK], DatanodeInfoWithStorage[10.125.8.217:1019,DS-baa9e3c7-02de-46c7-9fd1-3a61246e0188,DISK]]
    1. BP-1143747467-10.125.40.142-1413584797204:blk_1099955773_26226797 len=130887907 repl=2 [DatanodeInfoWithStorage[10.125.8.222:1019,DS-14e74b1e-3ba4-4998-bd19-664ea49168cc,DISK], DatanodeInfoWithStorage[10.125.8.218:1019,DS-24818377-8e89-4665-9a96-34da8ffab828,DISK]]
    
    /user/lngo/intro-to-hadoop/ml-10M100K/split_ratings.sh 1304 bytes, 1 block(s):  OK
    0. BP-1143747467-10.125.40.142-1413584797204:blk_1099955774_26226798 len=1304 repl=2 [DatanodeInfoWithStorage[10.125.8.222:1019,DS-9ea52fe1-883e-40ee-bc9a-eba6ecbc5277,DISK], DatanodeInfoWithStorage[10.125.8.223:1019,DS-8dbde862-3337-4e48-89c8-a74b36ca9154,DISK]]
    
    /user/lngo/intro-to-hadoop/ml-10M100K/tags.dat 3584119 bytes, 1 block(s):  OK
    0. BP-1143747467-10.125.40.142-1413584797204:blk_1099955775_26226799 len=3584119 repl=2 [DatanodeInfoWithStorage[10.125.8.216:1019,DS-49b8edac-df81-4da7-93ea-061cd9946db1,DISK], DatanodeInfoWithStorage[10.125.8.211:1019,DS-50be616b-aa46-49e2-a578-ea74fbead1e0,DISK]]
    
    Status: HEALTHY
     Total size:	274673315 B
     Total dirs:	2
     Total files:	7
     Total symlinks:		0
     Total blocks (validated):	8 (avg. block size 34334164 B)
     Minimally replicated blocks:	8 (100.0 %)
     Over-replicated blocks:	0 (0.0 %)
     Under-replicated blocks:	0 (0.0 %)
     Mis-replicated blocks:		0 (0.0 %)
     Default replication factor:	2
     Average block replication:	2.0
     Corrupt blocks:		0
     Missing replicas:		0 (0.0 %)
     Number of data-nodes:		40
     Number of racks:		1
    FSCK ended at Fri Jul 22 15:04:10 EDT 2016 in 2 milliseconds
    
    
    The filesystem under path '/user/lngo/intro-to-hadoop' is HEALTHY


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
