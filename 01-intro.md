---
layout: lesson
title: Introduction to HPC on the Palmetto Cluster
subtitle: Introduction to Palmetto and accessing the cluster
minutes: 45
---

> ## Learning objectives {.objectives}
> * Learn the basic cluster terminology,
    differentiate between nodes, cores, threads
> * Understand the structure of the cluster
    (login nodes, job scheduler, etc.)
> * Access the cluster with ssh
> * Understand the cluster filesystem set-up

## Accessing the cluster via SSH

The Palmetto cluster runs the Linux operating system,
specifically, [Scientific Linux](https://www.scientificlinux.org/).
Unlike familiar operating systems such as
Microsoft Windows or Apple OS X, however,
you will primarily interact with the cluster via
a *command-line interface*
(as opposed to a *graphical* interface).

Interacting with the system through a simple command-line interface
is required because there is no room for the
computational "overhead" of running a graphical interface,
especially not on a large HPC cluster with
hundreds of users connecting to the system through
remote network connections.
Besides, the command line interface is much better suited
to automating tasks and performing repetitive actions
than the graphical interface.

To be able to run commands on the Palmetto from your own machine,
you will first need to be able to log in to the Palmetto.
If you run Mac OS X or Linux on your machine,
you can do this by opening a terminal
and using the `ssh` command:

~~~{.bash}
$ ssh username@user.palmetto.clemson.edu
~~~

If you run Windows,
you will use the SSH Secure Shell to log in.
Click on  `File > Quick Connect`,
and use the following parameters (whichever required):

* Host name: `user.palmetto.clemson.edu`  
* User name: Clemson username   
* Port number: 22  
* Authentication method: none specified

When logged in,
you are presented with a welcome message
and the following prompt:

~~~{.bash}
[username@user001 ~]$ 
~~~

The prompt tells you your username and which node
you are connected to -
`user001` is the "login" node.
The prompt also tells you your current directory,
i.e., `~`, which is short for your home directory `/home/username`.
We will hereby refer to the prompt as just `$`, i.e.,

~~~{.bash}
$ 
~~~

## Structure of the Palmetto Cluster

<img src="fig/palmetto-structure.png" \
     alt="Structure of the Palmetto Cluster" \
     style="height:350px">

The Palmetto cluster has several "compute" nodes
that can perform fast calculations on large amounts of data.
It also has a few so-called "service" nodes,
that are *not* meant for this purpose.
Instead, they are meant to help users perform other actions
such as transfering code and data to and from the cluster.

The most important of these "service" nodes is
the login node `user001`.
The login node runs a "server" program
that listens for remote logins.
On our own machines, we run a "client" program
(`ssh`) that can talk to this server.
Our client program passes our login credentials to this server,
and if we are allowed to log in,
the server runs a shell for us on whatever remote
computer it is running on (`user0001`).
