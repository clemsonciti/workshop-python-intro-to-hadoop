
---
layout: lesson
title: Introduction to Hadoop
subtitle: Interacting with Hadoop
minutes: 20
---

> ## Learning objectives {.objectives}
> * Learn how to use the Hadoop command in Jupyter shells.
> * Learn how to access the web UI of the Hadoop Distributed File System.

In this workshop, we will leverage the Jupyter infrastructure at Clemson
University to directly interact with Hadoop. Technical details on how to use 
the Jupyter infrastructure can be found at **https://clemsonciti.github.io/jupyterhub-userdocs/**

For this workshop, the default codes inside a cell will be interpreted as Python
 language. However, any line that begins with **!** will be interpreted as a
 Linux system command.


```python
print ("Hello World")
```

    Hello World



```python
!ls /
```

    bin	    common1  feltus	    lost+found	panicle   selinux   usr
    bioengr     cugi     home	    media	proc	  smlc	    var
    boot	    cvmfs    install	    misc	root	  software  xcatpost
    cgroup	    dev      lib	    mnt		sbin	  srv	    zfs
    collective  etc      lib64	    net		scratch1  sys
    common	    fast     local_scratch  opt		scratch2  tmp


## HDFS commands
HDFS provides a set of commands for users to interact with the system from a
 Linux-based terminal. To view all available HDFS systems commands, run the
 following in a cell:


```python
!ssh dsciu001 hdfs
```

    Usage: hdfs [--config confdir] [--loglevel loglevel] COMMAND
           where COMMAND is one of:
      dfs                  run a filesystem command on the file systems supported in Hadoop.
      classpath            prints the classpath
      namenode -format     format the DFS filesystem
      secondarynamenode    run the DFS secondary namenode
      namenode             run the DFS namenode
      journalnode          run the DFS journalnode
      zkfc                 run the ZK Failover Controller daemon
      datanode             run a DFS datanode
      dfsadmin             run a DFS admin client
      envvars              display computed Hadoop environment variables
      haadmin              run a DFS HA admin client
      fsck                 run a DFS filesystem checking utility
      balancer             run a cluster balancing utility
      jmxget               get JMX exported values from NameNode or DataNode.
      mover                run a utility to move block replicas across
                           storage types
      oiv                  apply the offline fsimage viewer to an fsimage
      oiv_legacy           apply the offline fsimage viewer to an legacy fsimage
      oev                  apply the offline edits viewer to an edits file
      fetchdt              fetch a delegation token from the NameNode
      getconf              get config values from configuration
      groups               get the groups which users belong to
      snapshotDiff         diff two snapshots of a directory or diff the
                           current directory contents with a snapshot
      lsSnapshottableDir   list all snapshottable dirs owned by the current user
    						Use -help to see options
      portmap              run a portmap service
      nfs3                 run an NFS version 3 gateway
      cacheadmin           configure the HDFS cache
      crypto               configure HDFS encryption zones
      storagepolicies      list/get/set block storage policies
      version              print the version
    
    Most commands print help when invoked w/o parameters.


For this workshop, we are interested in file system commands. Create a new cell
 and run the following:


```python
!ssh dsciu001 hdfs dfs
```

    Java HotSpot(TM) 64-Bit Server VM warning: ignoring option MaxPermSize=512m; support was removed in 8.0
    Usage: hadoop fs [generic options]
    	[-appendToFile <localsrc> ... <dst>]
    	[-cat [-ignoreCrc] <src> ...]
    	[-checksum <src> ...]
    	[-chgrp [-R] GROUP PATH...]
    	[-chmod [-R] <MODE[,MODE]... | OCTALMODE> PATH...]
    	[-chown [-R] [OWNER][:[GROUP]] PATH...]
    	[-copyFromLocal [-f] [-p] [-l] <localsrc> ... <dst>]
    	[-copyToLocal [-p] [-ignoreCrc] [-crc] <src> ... <localdst>]
    	[-count [-q] [-h] [-v] [-t [<storage type>]] <path> ...]
    	[-cp [-f] [-p | -p[topax]] <src> ... <dst>]
    	[-createSnapshot <snapshotDir> [<snapshotName>]]
    	[-deleteSnapshot <snapshotDir> <snapshotName>]
    	[-df [-h] [<path> ...]]
    	[-du [-s] [-h] <path> ...]
    	[-expunge]
    	[-find <path> ... <expression> ...]
    	[-get [-p] [-ignoreCrc] [-crc] <src> ... <localdst>]
    	[-getfacl [-R] <path>]
    	[-getfattr [-R] {-n name | -d} [-e en] <path>]
    	[-getmerge [-nl] <src> <localdst>]
    	[-help [cmd ...]]
    	[-ls [-d] [-h] [-R] [<path> ...]]
    	[-mkdir [-p] <path> ...]
    	[-moveFromLocal <localsrc> ... <dst>]
    	[-moveToLocal <src> <localdst>]
    	[-mv <src> ... <dst>]
    	[-put [-f] [-p] [-l] <localsrc> ... <dst>]
    	[-renameSnapshot <snapshotDir> <oldName> <newName>]
    	[-rm [-f] [-r|-R] [-skipTrash] [-safely] <src> ...]
    	[-rmdir [--ignore-fail-on-non-empty] <dir> ...]
    	[-setfacl [-R] [{-b|-k} {-m|-x <acl_spec>} <path>]|[--set <acl_spec> <path>]]
    	[-setfattr {-n name [-v value] | -x name} <path>]
    	[-setrep [-R] [-w] <rep> <path> ...]
    	[-stat [format] <path> ...]
    	[-tail [-f] <file>]
    	[-test -[defsz] <path>]
    	[-text [-ignoreCrc] <src> ...]
    	[-touchz <path> ...]
    	[-truncate [-w] <length> <path> ...]
    	[-usage [cmd ...]]
    
    Generic options supported are
    -conf <configuration file>     specify an application configuration file
    -D <property=value>            use value for given property
    -fs <local|namenode:port>      specify a namenode
    -jt <local|resourcemanager:port>    specify a ResourceManager
    -files <comma separated list of files>    specify comma separated files to be copied to the map reduce cluster
    -libjars <comma separated list of jars>    specify comma separated jar files to include in the classpath.
    -archives <comma separated list of archives>    specify comma separated archives to be unarchived on the compute machines.
    
    The general command line syntax is
    bin/hadoop command [genericOptions] [commandOptions]
    


We can see that HDFS provides a number of file system commands that are quite
similar to their Linux counterpart. For example, ***-chown*** and ***-chmod***
 change ownership and permission of HDFS files and directories, ***-ls*** lists
  content of a directory, ***-mkdir*** creates new directory, ***-rm*** removes
   files and directories, and so on.

> ## ***hadoop fs*** and ***hdfs dfs*** {.callout}
>
> ***hadoop fs*** is an older syntax for ***hdfs dfs***. While both commands
> produce the same results, you are encouraged to use ***hdfs dfs*** instead.

When a Hadoop cluster is first started, there is no data. Users usually import
 data into the cluster from the traditional Linux-based file system. This is
 done by using the commandOption ***-put***. Vice versa, to move data from HDFS
 back to a Linux-based file system, commandOption ***-get*** is used.

> ## Hadoop Distributed File System is not the Linux File System {.callout}
>
> It is important to distinguish between the files and directories that are
> stored on HDFS and those that are stored on the Linux File Systems. In the
> Hadoop usage guide, the prefix ***local*** implies a path to a file/directory
> that is on a Linux File System. Anything else implies a path to a
> file/directory on HDFS

## Check your understanding: Using Jupyter shell to download data {.callout}

Create a directory named **intro-to-hadoop** in your home directory on Palmetto

From inside this directory, run the following command to get data from github


```python
!wget https://github.com/clemsonciti/hadoop-python-01-workshop/raw/gh-pages/data/gutenberg-shakespeare.txt
```

    --2016-07-22 12:29:05--  https://github.com/clemsonciti/hadoop-python-01-workshop/raw/gh-pages/data/gutenberg-shakespeare.txt
    Resolving github.com... 192.30.253.112
    Connecting to github.com|192.30.253.112|:443... connected.
    HTTP request sent, awaiting response... 302 Found
    Location: https://raw.githubusercontent.com/clemsonciti/hadoop-python-01-workshop/gh-pages/data/gutenberg-shakespeare.txt [following]
    --2016-07-22 12:29:06--  https://raw.githubusercontent.com/clemsonciti/hadoop-python-01-workshop/gh-pages/data/gutenberg-shakespeare.txt
    Resolving raw.githubusercontent.com... 151.101.20.133
    Connecting to raw.githubusercontent.com|151.101.20.133|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 5447744 (5.2M) [text/plain]
    Saving to: “gutenberg-shakespeare.txt”
    
    100%[======================================>] 5,447,744   13.7M/s   in 0.4s    
    
    2016-07-22 12:29:07 (13.7 MB/s) - “gutenberg-shakespeare.txt” saved [5447744/5447744]
    


## Check your understanding: View files and directories on HDFS {.challenge}

View the content of your HDFS user directory (/user/**your-username**) on
 Cypress

## Check your understanding: Create directory on HDFS {.challenge}

Create a directory in your HDFS user directory named **intro-to-hadoop**

## Check your understanding: Import file to HDFS {.challenge}

Copy the file ***gutenberg-shakespeare.txt*** from Palmetto to this newly
 created **intro-to-hadoop** directory on HDFS using **put**. View the content of
 the **intro-to-hadoop** directory to confirm that the file has been
 successfully uploaded.
 
Use `wget` to download the movie rating data from https://github.com/clemsonciti/hadoop-python-01-workshop/raw/gh-pages/data/ml-10m.zip. Use `unzip` to decompress the file. Copy the decompressed directory, **ml-10M100K**, into the
**intro-to-hadoop** directory on HDFS using **put**. Run `hdfs fsck` on this directory to validate the status of 
the uploaded directory. 
