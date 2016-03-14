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

## Basic terminology

Node:
Core:
Thread


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
you will use the SSH Secure Shell with the following parameters:

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
We will hereby refer to the prompt as just `$`.

## Structure of the Palmetto Cluster

TODO
