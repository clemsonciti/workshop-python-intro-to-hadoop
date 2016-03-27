---
layout: page
title: Introduction to Linux
subtitle: Files and Directories
minutes: 15
---
> ## Learning Objectives {.objectives}
>
> *   Explain the similarities and differences between a
>     file and a directory.
> *   Translate an absolute path into a relative path and vice versa.
> *   Construct absolute and relative paths that
>     identify specific files and directories.
> *   Explain the steps in the shell's read-run-print cycle.
> *   Identify the actual command, flags,
>     and filenames in a command-line call.
> *   Demonstrate the use of tab completion, and explain its advantages.

The part of the operating system responsible for
managing files and directories
is called the **file system**.
It organizes our data into files,
which hold information,
and directories (also called "folders"),
which hold files or other directories.

Several commands are frequently used to create,
inspect, rename, and delete files and directories.
In this lesson, we will begin to explore them. 

Type the command `whoami`,
then press the Enter key (sometimes marked Return) to
send the command to the shell.
The command's output is the ID of the current user,
i.e.,
it shows us who the shell thinks we are:

~~~ {.bash}
$ whoami
~~~
~~~ {.output}
nelle
~~~

More specifically, when we type `whoami` the shell:

1.  finds a program called `whoami`,
2.  runs that program,
3.  displays that program's output, then
4.  displays a new prompt to tell us that it's ready for more commands.

> ## Username Variation {.callout}
>
> In this lesson, we have used the username `nelle` (associated 
> with our hypothetical scientist Nelle)
> in example input and output throughout.  
> However, when 
> you type this lesson's commands on your computer,
> you should see and use something different, 
> namely,
> the username associated with the user account on your computer. This 
> username will be the output from `whoami`.  In 
> what follows, `nelle` should always be replaced by that username.  

Next,
let's find out where we are by running a command called `pwd`
(which stands for "print working directory").
At any moment,
our **current working directory**
is our current default directory,
i.e.,
the directory that the computer assumes we want to run commands in
unless we explicitly specify something else.
Here,
the computer's response is `/home/nelle`,
which is Nelle's **home directory**:

~~~ {.bash}
$ pwd
~~~
~~~ {.output}
/home/nelle
~~~

To understand what a "home directory" is,
let's have a look at how the file system as a whole is organized.  For the 
sake of example, we'll be 
illustrating the filesystem on the Palmetto cluster.
After this illustration,
you'll be learning commands to explore your own filesystem, 
which will be constructed in a similar way, but not be exactly identical.  

On the cluster, the filesystem looks like this: 

![The File System](fig/filesystem.svg)

At the top is the **root directory**
that holds everything else.
We refer to it using a slash character `/` on its own;
this is the leading slash in `/home/nelle`.

Inside that directory are several other directories:
`bin` (which is where some built-in programs are stored),
`tmp` (for temporary files that don't need to be stored long-term),
`home` (where users' personal directories are located),
and so on.  

We know that our current working directory `/home/nelle` is stored inside `/home`
because `/home` is the first part of its name.
Similarly,
we know that `/home` is stored inside the root directory `/`
because its name begins with `/`.

> ## Slashes {.callout}
>
> Notice that there are two meanings for the `/` character.
> When it appears at the front of a file or directory name,
> it refers to the root directory. When it appears *inside* a name,
> it's just a separator.

Underneath `/home`,
we find one directory for each user with an account on the Palmetto cluster.

![Home Directories](fig/home-directories.svg)

The Mummy's files are stored in `/home/imhotep`,
Wolfman's in `/home/larry`,
and Nelle's in `/home/nelle`.  Because Nelle is the user in our 
examples here, this is why we get `/home/nelle` as our home directory.  
Typically, when you open a new command prompt you will be in 
your home directory to start.  

Now let's learn the command that will let us see the contents of our 
own filesystem.  We can see what's in our home directory by running `ls`,
which stands for "listing":

~~~ {.bash}
$ ls
~~~

~~~ {.output}
data-shell
~~~

The output shows us the `data-shell` directory
that we just downloaded.
(If you have other files or directories already stored
in your home directory,
you'll see them in the output too).

`ls` prints the names of the files and directories in the current directory in 
alphabetical order,
arranged neatly into columns.
We can use `ls` to look at the contents of
directories other than the current directory as well.
Let's list the files and directories inside
the `data-shell` directory:

~~~{.bash}
$ ls data-shell
~~~

~~~{.output}
creatures  data  Desktop  molecules  north-pacific-gyre  notes.txt  pizza.cfg  solar.pdf  writing
~~~

We can make its output more comprehensible by using the **flag** `-F`,
which tells `ls` to add a trailing `/` to the names of directories:

~~~ {.bash}
$ ls -F data/shell
~~~

~~~ {.output}
creatures/  data/  Desktop/  molecules/  north-pacific-gyre/  notes.txt  pizza.cfg  solar.pdf  writing/
~~~

Here,
we can see that our the `data-shell` directory contains mostly **sub-directories**.
Any names in your output that don't have trailing slashes,
are plain old **files**.
And note that there is a space between `ls` and `-F`:
without it,
the shell thinks we're trying to run a command called `ls-F`,
which doesn't exist.

> ## Parameters vs. Arguments {.callout}
>
> According to [Wikipedia](https://en.wikipedia.org/wiki/Parameter_(computer_programming)#Parameters_and_arguments),
> the terms argument and **parameter**
> mean slightly different things.
> In practice,
> however,
> most people use them interchangeably or inconsistently,
> so we will too.

As you may now see, using a bash shell is strongly dependent on the idea that 
your files are organized in an hierarchical file system.  
Organizing things hierarchically in this way helps us keep track of our work:
it's possible to put hundreds of files in our home directory,
just as it's possible to pile hundreds of printed papers on our desk,
but it's a self-defeating strategy.

We'd like to start working with the files
inside the `data-shell` directory,
but doing that from our home directory can be inconvenient---especially
if we want to work with files that are located
in subdirectories of `data-shell`.
Fortunately, we can actually change our location to a different directory,
so we are no longer located in
our home directory.

The command to change locations is `cd` followed by a 
directory name to change our working directory.
`cd` stands for "change directory",
which is a bit misleading:
the command doesn't change the directory,
it changes the shell's idea of what directory we are in.

Let's say we want to move to the `data-shell` directory.  We can 
use the following command to get there: 

~~~ {.bash}
$ cd data-shell
~~~

This command will move us from our home directory into
the `data-shell` directory.
`cd` doesn't print anything,
but if we run `pwd` after it, we can see that we are now 
in `/home/nelle/data-shell/`.
If we run `ls` without arguments now,
it lists the contents of `/home/nelle/data-shell/`,
because that's where we now are:

~~~ {.bash}
$ pwd
~~~

~~~ {.output}
creatures  data  Desktop  molecules  north-pacific-gyre  notes.txt  pizza.cfg  solar.pdf  writing
~~~

Of course, the output is the same as before:
we're still looking at the contents of `/home/nelle/data-shell`,
but now we're doing it from the same directory.

Let's now change directories to the `data` directory:

~~~{.bash}
$ cd data
~~~

To confirm we're in the right directory, let's use `pwd`:

~~~{.bash}
$ pwd
~~~

~~~{.output}
/home/nelle/data-shell/data
~~~

And now let's have a look at the
contents of this directory.
We'll use the `-F` flag to
differentiate between files and directories here.

~~~{.bash}
$ ls -F
~~~

~~~ {.output}
amino-acids.txt   elements/     pdb/	        salmon.txt
animals.txt       morse.txt     planets.txt     sunspot.txt
~~~

We now know how to go down the directory tree:
how do we go up?  We might try the following: 

~~~{.bash}
$ cd data-shell
~~~

~~~{.error}
-bash: cd: data-shell: No such file or directory
~~~

But we get an error!  Why is this?  

With our methods so far, 
`cd` can only see sub-directories inside your current directory.  There are 
different ways to see directories above your current location; we'll start 
with the simplest.  

There is a shortcut in the shell to move up one directory level
that looks like this: 

~~~ {.bash}
$ cd ..
~~~

`..` is a special directory name meaning
"the directory containing this one",
or more succinctly,
the **parent** of the current directory.
Sure enough,
if we run `pwd` after running `cd ..`, we're back in `/home/nelle/data-shell`:

~~~ {.bash}
$ pwd
~~~
~~~ {.output}
/home/nelle/data-shell
~~~

The special directory `..` doesn't usually show up when we run `ls`.  If we want 
to display it, we can give `ls` the `-a` flag:

~~~ {.bash}
$ ls -F -a
~~~
~~~ {.output}
./                  creatures/          notes.txt
../                 data/               pizza.cfg
.bash_profile       molecules/          solar.pdf
Desktop/            north-pacific-gyre/ writing/
~~~

`-a` stands for "show all";
it forces `ls` to show us file and directory names that begin with `.`,
such as `..` (which, if we're in `/home/nelle`, refers to the `/home` directory)
As you can see,
it also displays another special directory that's just called `.`,
which means "the current working directory".
It may seem redundant to have a name for it,
but we'll see some uses for it soon.

> ## Other Hidden Files {.callout}
> 
> In addition to the hidden directories `..` and `.`, you'll also see a file 
> called `.bash_profile`. This file usually 
> contains settings to customize the shell.  There may also be similar files called 
> `.bashrc` or `.bash_login` in your own home directory. The `.` prefix is 
> used to prevent these 
> configuration files from cluttering the terminal when a standard `ls` command is used.

> ## Orthogonality {.callout}
>
> The special names `.` and `..` don't belong to `ls`;
> they are interpreted the same way by every program.
> For example,
> if we are in `/home/nelle/data`,
> the command `ls ..` will give us a listing of `/home/nelle`.
> When the meanings of the parts are the same no matter how they're combined,
> programmers say they are **orthogonal**:
> Orthogonal systems tend to be easier for people to learn
> because there are fewer special cases and exceptions to keep track of.

These then, are the basic commands for navigating the filesystem on your computer: 
`pwd`, `ls` and `cd`.  Let's explore some variations on those commands.  What happens 
if you type `cd` on its own, without giving 
a directory?  

~~~ {.bash}
$ cd
~~~

How can you check what happened?  `pwd` gives us the answer!  

~~~ {.bash}
$ pwd
~~~
~~~ {.output}
/home/nelle
~~~

It turns out that `cd` without an argument will return you to your home directory, 
which is great if you've gotten lost in your own filesystem.  

Let's try returning to the `data` directory from before.
One way to do this is to navigate first into the `data-shell` directory,
and then into the `data` directory:

~~~{.bash}
$ cd data-shell
$ cd data
~~~

But we can actually string together the above commands
in the following way:

~~~ {.bash}
$ cd data-shell/data
~~~

Check that we've moved to the right place by running `pwd` and `ls -F`.  

If we want to move up one level from the shell directory, we could use `cd ..`.  But 
there is another way to move to any directory, regardless of your 
current location.

So far, when specifying directory names, or even a directory path (as above), 
we have been using **relative paths**.  When you use a relative path with a command 
like `ls` or `cd`, it tries to find that location  from where we are,
rather than from the root of the file system.  

However, it is possible to specify the **absolute path** to a directory by 
including its entire path from the root directory, which is indicated by a 
leading slash.  The leading `/` tells the computer to follow the path from 
the root of the file system, so it always refers to exactly one directory,
no matter where we are when we run the command.

This allows us to move to our data-shell directory from anywhere on 
the filesystem (including from inside `data`).  To find the absolute path 
we're looking for, we can use `pwd` and then extract the piece we need 
to move to `data-shell`.  

~~~ {.bash}
$ pwd
~~~
~~~ {.output}
/home/nelle/data-shell/data
~~~
~~~ {.bash}
$ cd /home/nelle/data-shell
~~~

Run `pwd` and `ls -F` to ensure that we're in the directory we expect.  

> ## Two More Shortcuts {.callout}
>
> The shell interprets the character `~` (tilde) at the start of a path to
> mean "the current user's home directory". For example, if Nelle's home
> directory is `/home/nelle`, then `~/data-shell` is equivalent to
> `/home/nelle/data-shell`. This only works if it is the first character in the
> path: `here/there/~/elsewhere` is *not* `here/there/home/nelle/elsewhere`. 
> 
> Another shortcut is the `-` (dash) character.  `cd` will translate `-` into
> *the previous directory I was in*, which is faster than having to remember, 
> then type, the full path.  This is a *very* efficient way of moving back 
> and forth between directories. The difference between `cd ..` and `cd -` is 
> that the former brings you *up*, while the latter brings you *back*. 

### Nelle's Pipeline: Organizing Files

Knowing just this much about files and directories,
Nelle is ready to organize the files that the protein assay machine will create.
First,
she creates a directory called `north-pacific-gyre`
(to remind herself where the data came from).
Inside that,
she creates a directory called `2012-07-03`,
which is the date she started processing the samples.
She used to use names like `conference-paper` and `revised-results`,
but she found them hard to understand after a couple of years.
(The final straw was when she found herself creating
a directory called `revised-revised-results-3`.)

> ## Output sorting {.callout}
>
> Nelle names her directories "year-month-day",
> with leading zeroes for months and days,
> because the shell displays file and directory names in alphabetical order.
> If she used month names,
> December would come before July;
> if she didn't use leading zeroes,
> November ('11') would come before July ('7'). Similarly, putting the year first 
> means that June 2012 will come before June 2013.

Each of her physical samples is labelled according to her lab's convention
with a unique ten-character ID,
such as "NENE01729A".
This is what she used in her collection log
to record the location, time, depth, and other characteristics of the sample,
so she decides to use it as part of each data file's name.
Since the assay machine's output is plain text,
she will call her files `NENE01729A.txt`, `NENE01812A.txt`, and so on.
All 1520 files will go into the same directory.

If she is in the `data-shell` directory,
Nelle can see what files she has using the command:

~~~ {.bash}
$ ls north-pacific-gyre/2012-07-03/
~~~

This is a lot to type,
but she can let the shell do most of the work through what is called **tab completion**.
If she types:

~~~ {.bash}
$ ls nor
~~~

and then presses tab (the tab key on her keyboard),
the shell automatically completes the directory name for her:

~~~ {.bash}
$ ls north-pacific-gyre/
~~~

If she presses tab again,
Bash will add `2012-07-03/` to the command,
since it's the only possible completion.
Pressing tab again does nothing,
since there are 19 possibilities;
pressing tab twice brings up a list of all the files,
and so on.
This is called **tab completion**,
and we will see it in many other tools as we go on.

> ## Many ways to do the same thing - absolute vs relative paths {.challenge}
>
> For a hypothetical filesystem location of `/home/amanda/data/`, 
> select each of the below commands that Amanda could use to navigate to her home directory, 
> which is `home/amanda`.  
> 
>1.  `cd .`
>2.  `cd /`
>3.  `cd /home/amanda`
>4.  `cd ../..`
>5.  `cd ~`
>6.  `cd home`
>7.  `cd ~/data/..`
>8.  `cd`
>9.  `cd ..`

> ## Listing files by size {.challenge}
> 
> Navigate to the directory `data-shell/data/pdb`.
> Typing in `ls`,
> you should see several files with the extension `.pdb`.
> These are *protein data bank* files,
> that express the three-dimensional structure
> of large organic molecules.
>
> Note that the molecules are arranged
> in alphabetical order.
> We'd like instead to list them by *size*
> (number of bytes or characters).
> We know that there's a switch that we can
> provide to the `ls` command to do this,
> but we're not sure which one.
> Type in `man ls` to get information about `ls`
> and the various command switches available.
>
> Find the appropriate switch to list the contents
> of this directory by size.
