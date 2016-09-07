
---
layout: page
title: Introduction to Hadoop
subtitle: Introducing Apache Hadoop
minutes: 5
---
> ## Learning Objectives {.objectives}
>
> *   Explain the motivation and history behind the creation of Apache Hadoop.
> *   Explain the differences between Hadoop Distributed File System and other large scale storage solutions.

A quick history of Hadoop:

-   2002: Doug Cutting and Mike Carafella started a project to build an open-source search engine called Nutch. 
    A component of this project was a web crawler that can crawl and index the Internet.
-   2003: Google released a research paper on its in-house data storage system 
    called [Google File System](http://dl.acm.org/citation.cfm?id=945450) (GFS).
-   2004: Google released another research paper on the programming approach to process data stored on GFS, 
    called [MapReduce](http://dl.acm.org/citation.cfm?id=1327492).
-   2005: Cutting and Carafelle rebuilt the underlying file management system and processing framework of Nutch 
    based on the architectural design of Google's GFS and MapReduce.
-   2006: The adaptations of Google's GFS and MapReduce are converted into a single open source project called 
    Hadoop, which is sponsored by Yahoo and led by Doug Cutting.
-   2007: Yahoo maintains a 1000-node production cluster.
-   2008: Hadoop becomes the platform of Yahoo's web index. Hadoop wins record for world fastest 
    system to sort one terabyte of data (209 seconds using a 910-node cluster). Hadoop becomes a 
    top-level open source project of Apache Foundation. First Hadoop commercial distributor led 
    by a former Google employee, Cloudera, is founded.
-   2009: Hadoop sorts one terabyte of data in 62 seconds and one petabyte of data in 16.25 hours. Second Hadoop 
    commercial distributor, MapR, is formed.
-   2011: Yahoo spins off its own Hadoop comnmercial distributor, Hortonworks.
-   2012: Apache Hadoop 1.0 is released.

## What Makes HDFS Different?

There are three approaches in storing data for processing purposes:

-   Data are stored on a single computer's local hard drive and can be processed by programs running on 
    the same computer. This is how most people manage their data in normal daily tasks.
-   Data are stored on remote storage systems. These systems are often consisted of multiple hard drives 
    to support reading/writing large amount of data. Software programs accessing these data are located 
    on a different set of computers, and the data must be copied from the storage systems to these computers 
    over the network. This is the storage model of the Palmetto Supercomputer.
-   Data are stored on a set of computers, and the software programs accessing these data also runs on 
    the same set of computers. This is the storage model of the Hadoop Distributed File System.

<img src="fig/StorageSimplified.png" \
     alt="Simple Presentation of Storage Models" \
     style="height:500px">

HDFS uses the following design assumptions:

-   Hardware failure is the norm rather than the exception. Companies like Yahoo or Google run data 
    warehouses that have thousands of machines. Rather than trying to prevent failure, it is more realistic 
    to focus on failure recovery.
-   Data arrives as a stream. HDFS is specifically designed for programs that process massive amount of data in 
    batches.
-   The amount of data to be processed is very large.
-   Data are written once but read many times (no data modification).
-   It is cheaper to move the computation (e.g., copy the programs) than to move the data.
-   The set of computers contains different types of hardware and software.


## Movie Ratings and Recommendation

An independent movie company is looking to invest in a new movie project. With limited finance, the company wants to 
analyze the reaction of audiences, particularly toward various movie genres, in order to identify beneficial 
movie project to focus on. The company relies on data collected from a publicly available recommendation service 
by [MovieLens](http://dl.acm.org/citation.cfm?id=2827872). This 
[dataset](http://files.grouplens.org/datasets/movielens/ml-10m-README.html) 
contains "**10,000,054** ratings and **95,580** tag applications across **10,681** movies. These data were created 
by **71,567** users between January 09, 1995 and January 29, 2016." 

From this dataset, several analyses are possible, include the followings:
1.   Find movies which have the highest ratings over the years and identify the corresponding genre.
2.   Find genres which have the highest ratings over the years.
3.   Find users who rate movies most frequently in order to contact them for in-depth marketing analysis.

These types of analyses, which are somewhat ambiguous, demand the ability to quickly process large amount of data in 
elatively short amount of time for decision support purposes. In these situations, the sizes of the data typically 
make analysis done on a single machine impossible and analysis done using a remote storage system impractical. For 
remainder of the lessons, we will learn how HDFS provides the basis to store massive amount of data and to enable 
the programming approach to analyze these data.

