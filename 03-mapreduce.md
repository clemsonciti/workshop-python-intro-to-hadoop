
---
layout: page
title: Introduction to Hadoop
subtitle: Introducing the MapReduce Programming Paradigm
minutes: 20
---
> ## Learning Objectives {.objectives}
>
> *   Understand the MapReduce programming paradigm
> *   Understand why the MapReduce programming paradigm is a natural approach
>     to handle HDFS data with the Hadoop MapReduce implementation
> *   Understand Key/Value pair    

MapReduce is a programming model that has its roots in functional programming.
The ideal targets for MapReduce are collections of data elements (lists, arrays,
sets ...). There are two core functions in MapReduce: Map and Reduce.

Map operates on all data elements of a collection by applying the same operation
(or same set of operations) to each individual element of this collection. The
outcome of Map is another collection of new data elements:


```python
input_data = [0,1,2,3,4]

def squared (x):
    return x * x

map_output_1 = list(map(squared, input_data))
print (map_output_1)
```

    [0, 1, 4, 9, 16]


Map operation to filter data:


```python
input_data = [0,1,2,3,4]

def squared (x):
    tmp = x * x
    if tmp > 4:
        return x * x

map_output_2 = list(map(squared, input_data))
print (map_output_2)
```

    [None, None, None, 9, 16]


Map operation to break up sentences into individual words:


```python
input_data = ["Ask not what your data can do for you", "ask what you can do for your data"]

def parse_words (x):
    return x.split()

map_output_3 = list(map(parse_words, input_data))
print (map_output_3)
```

    [['Ask', 'not', 'what', 'your', 'data', 'can', 'do', 'for', 'you'], ['ask', 'what', 'you', 'can', 'do', 'for', 'your', 'data']]


A Reduce function will operate on the outcome of a Map operation to either
collapse or combine these new data elements into either a single value or a
subset of elements.

Reduce function that accumulates values of a list using Python's built-in
***reduce*** function:


```python
import functools
def sum(tmp, x):
    return tmp + x

reduce_output_1 = functools.reduce(sum, map_output_1)
print (reduce_output_1)
```

    30


A user-defined reduce function using standard for loop:


```python
def sum_reduce(x):
    sum = 0
    for data_element in x:
        sum = sum + data_element
    return sum

reduce_output_2 = sum_reduce(map_output_1)
print(reduce_output_2)
```

    30


## Check your understanding: Write a MapReduce procedure {.challenge}

Given the following data set [-2,5,-10,4,7,9,1], find the largest squared value.

## Hadoop MapReduce

We recall from lessons [1](00-intro.html) and [3](02-filedir.html) that HDFS
divides big data files into small blocks and distributes these blocks across a
network of computers. In order to support the ***data locality*** concept, we
need to bring the required computation to these data blocks. The MapReduce
programming paradigm lends itself naturally to this concept.

The Map operation can be thought of as having the same operation being applied
to each data elements in a collection. Therefore, in HDFS setting, the same
Map operation can be applied to individual data blocks of a file. As these
blocks are distributed across computers, the processors on these computers can
execute the operations in parallel, significantly improving performance.

After the Map operation is completed, since the blocks are located on different
computers, the output data of the Map operation is naturally also distributed
across these computers. For the Reduce operation, a number of issues must be
addressed, such as:  

1. How can we gather the map output data for reduction?
2. How can we also speed up the Reduce process?

Hadoop MapReduce uses several mechanisms to resolve these issues.

**Key/Value Pair**: For Hadoop MapReduce, data are represented not as a single
data value, but as a tuple of Key and Value. The key could be a unique
identifier or a representative attribute of the data value. The key enables
the Hadoop MapReduce framework to group data values of the same type or
characteristics together.

**Shuffle**: Hadoop MapReduce will ***shuffles*** map output data across
computers to group data with the same key into collections. The Reduction
operation will be applied to these collections. As the collections will be
distributed, the Reduce process also happens in parallel.

**Partition**: Hadoop MapReduce will ***partition*** the placement of these
collections such that they are balanced across the computers and minimal data
transfer is needed.

Hadooop MapReduce carries default implementations of ***Shuffle*** and
***Partition*** functions. Together with the management of data distribution
via HDFS, that leaves users with only the task of developing the Map and the
Reduce operation, in which determining Key and Value is a critical step.
