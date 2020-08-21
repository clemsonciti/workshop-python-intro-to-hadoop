#!/bin/bash
# Set this to the location of hadoop-dist
export MY_HADOOP_DIR="/home/${USER}/hadoop_palmetto"
module load openjdk/1.8.0_222-b10-gcc/8.3.1
module load hadoop/3.2.1-gcc/8.3.1

set -x
echo "HADOOP_ROOT:" $HADOOP_ROOT
echo "JAVA_HOME:" $JAVA_HOME

hdfs --config ~/hadoop_palmetto/config dfsadmin -report
hdfs --config ~/hadoop_palmetto/config dfs -mkdir -p /user/$USER/test
hdfs --config ~/hadoop_palmetto/config dfs -ls /user/$USER/test
hdfs --config ~/hadoop_palmetto/config dfs -put /zfs/citi/complete-shakespeare.txt /user/$USER/test/
hdfs --config ~/hadoop_palmetto/config dfs -ls test/
yarn --config ~/hadoop_palmetto/config jar $HADOOP_ROOT/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar wordcount test/complete-shakespeare.txt test_output

hdfs --config ~/hadoop_palmetto/config dfs -ls -h test_output
hdfs --config ~/hadoop_palmetto/config dfs -rm -r test
hdfs --config ~/hadoop_palmetto/config dfs -rm -r test_output

