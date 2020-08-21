#!/bin/bash
# Set this to the location of hadoop-dist
export MY_HADOOP_DIR="/home/${USER}/hadoop_palmetto"
module load openjdk/1.8.0_222-b10-gcc/8.3.1
module load hadoop/3.2.1-gcc/8.3.1
pbsdsh sleep 5

echo "HADOOP_ROOT:" $HADOOP_ROOT
echo "JAVA_HOME:" $JAVA_HOME

# Set this to the location of the Hadoop Installation
export HADOOP_HOME="${HADOOP_ROOT}"
export HADOOP_MAPRED_HOME="${HADOOP_HOME}"
export HADOOP_COMMON_HOME="${HADOOP_HOME}"
export HADOOP_HDFS_HOME="${HADOOP_HOME}"
export HADOOP_YARN_HOME="${HADOOP_HOME}"
export HADOOP_CONF_DIR="${MY_HADOOP_DIR}/config"
export YARN_CONF_DIR="${MY_HADOOP_DIR}/config"
export HADOOP_COMMON_LIB_NATIVE_DIR="${HADOOP_HOME}/lib/native"
export HADOOP_OPTS="-Djava.library.path=${HADOOP_HOME}/lib"

export HADOOP_DATA_DIR="${TMPDIR}/hdfs/datanode"
export HADOOP_LOG_DIR="${TMPDIR}/hadoop/log"
export HADOOP_TMP_DIR="${TMPDIR}/hadoop/tmp"
export YARN_LOCAL_DIR="${TMPDIR}/yarn/data"
export YARN_LOG_DIR="${TMPDIR}/yarn/logs"

set -x
echo "Begin stopping Hadoop cluster ..."

time $HADOOP_ROOT/sbin/stop-yarn.sh --config ${HADOOP_CONF_DIR}
time $HADOOP_ROOT/sbin/stop-dfs.sh --config ${HADOOP_CONF_DIR}
