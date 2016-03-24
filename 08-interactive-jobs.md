---
layout: lesson
title: Introduction to HPC on the Palmetto Cluster
subtitle: Scheduling an interactive job
minutes: 20
---

> ## Learning objectives {.objectives}
> * Schedule an interactive job on the Palmetto
> * Learn about the difference resources and limits

The Palmetto cluster consists of several hundred "compute" nodes,
each equipped with CPUs and GPUs to do heavy computation.
The login node `user001` is a "service" node,
shared by all users,
and is meant only for tasks such as managing projects
(editing and moving files and directories),
and submitting batch scripts (about which we will learn shortly).

One way to use the palmetto is to login to a compute node.
You do this with the `qsub -I` command:

~~~{.bash}
qsub -I
~~~

~~~{.output}
qsub (Warning): Interactive jobs will be treated as not rerunnable
qsub: waiting for job 2725837.pbs02 to start
qsub: job 2725837.pbs02 ready
~~~

Note that the number `2725837` may be different for you.
Once you are logged in to a compute node,
your prompt will look slightly different:

~~~{.bash}
[username@node1466 ~]$ 
~~~

The prompt indicates that you are no longer
running a shell on the login node (`user001`),
but a compute node (`node1466` or similar).
When logged in to a compute node,
you can still edit and move files
in your home and other directories.
But any programs that you run will run
on the hardware available on that node.

By default,
you are awarded 1 core on 1 compute node with
1 GB of RAM for 30 minutes.
You can request more (or less) of each of these resources
by modifying the `qsub` command.
For instance, to use 2 CPU cores for 10 minutes:

~~~{.bash}
qsub -I -l select=1:ncpus=2,walltime=00:10:00
~~~

Here, we use `select=1` to specify the number of
"chunks" of hardware that we'd like.
The following command requests 4 "chunks" of hardware,
with 2 CPU cores, 4 GB of RAM *each* - for 2 minutes:

~~~{.bash}
qsub -I -l select=4:ncpus=2:mem=4gb,walltime=00:02:00
~~~
