#!/bin/bash
# Set this to the location of hadoop-dist
export MY_HADOOP_DIR="/home/${USER}/hadoop_palmetto"
module load openjdk/1.8.0_222-b10-gcc/8.3.1
module load hadoop/3.2.1-gcc/8.3.1

echo "HADOOP_ROOT:" $HADOOP_ROOT
echo "JAVA_HOME:" $JAVA_HOME

# Set this to the location of the Hadoop Installation
export HADOOP_HOME=$HADOOP_ROOT
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

# Set all of the Path and Classpath variables
export PATH=${JAVA_HOME}/bin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH  
export HADOOP_HOME_LIBS=${HADOOP_HOME}/share/hadoop
export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${HADOOP_HOME_LIBS}/common/*
export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${HADOOP_HOME_LIBS}/common/lib/*
export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${HADOOP_HOME_LIBS}/mapreduce/*
export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${HADOOP_HOME_LIBS}/mapreduce/lib/*
export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${HADOOP_HOME_LIBS}/yarn/*
export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${HADOOP_HOME_LIBS}/yarn/lib/*
export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${HADOOP_HOME_LIBS}/hdfs/*
export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${HADOOP_HOME_LIBS}/hdfs/lib/*
export CLASSPATH=${CLASSPATH}:${HADOOP_CLASSPATH}


# create the config, data, and log directories
rm -Rf $MY_HADOOP_DIR
rm -Rf $HADOOP_CONF_DIR
mkdir -p $MY_HADOOP_DIR
mkdir -p $HADOOP_CONF_DIR

NAMENODE=$1

echo "NameNode is:" $NAMENODE
echo $NAMENODE >> $HADOOP_CONF_DIR/masters

# resource manager located on the same node as namenode
RESOURCE=$1
export RESOURCE_NODE=$RESOURCE
export HISTORY_NODE=$RESOURCE

echo "Resource Manager Node is: $RESOURCE_NODE"
echo $RESOURCE_NODE >> $HADOOP_CONF_DIR/regionservers


# Copy all information to the configuration file (with all information on nodes)
echo "NameNode"
echo "    Identifier: $NAMENODE"
echo "    Services: NameNode, JobHistoryServer, HMaster"
echo ""
echo "Resource Manager Node"
echo "    Identifier: $NAMENODE"
echo "    Services: Resource Manager, Secondary NameNode"
echo ""

export CONFIG_TEMPLATE="/zfs/citi/hadoop/config_templates"
cp ${CONFIG_TEMPLATE}/core-site.xml.template $HADOOP_CONF_DIR/core-site.xml
cp ${CONFIG_TEMPLATE}/hdfs-site.xml.template $HADOOP_CONF_DIR/hdfs-site.xml
cp ${CONFIG_TEMPLATE}/yarn-site.xml.template $HADOOP_CONF_DIR/yarn-site.xml
cp ${CONFIG_TEMPLATE}/capacity-scheduler.xml $HADOOP_CONF_DIR/capacity-scheduler.xml
cp ${CONFIG_TEMPLATE}/log4j.properties $HADOOP_CONF_DIR/log4j.properties




# core-site.xml
sed -i 's:MASTER:'"$NAMENODE"':g' $HADOOP_CONF_DIR/core-site.xml
sed -i 's:HADOOP_DATA_DIR:'"$HADOOP_DATA_DIR"':g' $HADOOP_CONF_DIR/core-site.xml
sed -i 's:HADOOP_TMP_DIR:'"$HADOOP_TMP_DIR"':g' $HADOOP_CONF_DIR/core-site.xml

# hadoop-env.sh
echo "" >> $HADOOP_CONF_DIR/hadoop-env.sh
echo "# Overwrite location of the log directory" >> $HADOOP_CONF_DIR/hadoop-env.sh
echo "export HADOOP_LOG_DIR=$HADOOP_LOG_DIR" >> $HADOOP_CONF_DIR/hadoop-env.sh

# hdfs-site.xml
sed -i 's:HADOOP_DATA_DIR:'"$HADOOP_DATA_DIR"':g' $HADOOP_CONF_DIR/hdfs-site.xml
sed -i 's:USER:'"$USER"':g' $HADOOP_CONF_DIR/hdfs-site.xml

# mapred-site.xml
sed 's/<value>.*:/<value>'"$NAMENODE"':/g' ${CONFIG_TEMPLATE}/mapred-site.xml.template > $HADOOP_CONF_DIR/mapred-site.xml
sed -i 's:HISTORY_SERVER:'"$NAMENODE"':g' $HADOOP_CONF_DIR/mapred-site.xml
sed -i 's:HADOOPHOME:'"$HADOOP_HOME"':g' $HADOOP_CONF_DIR/mapred-site.xml

# yarn-site.xml
sed -i 's:RESOURCE_MANAGER:'"$RESOURCE_NODE"':g' $HADOOP_CONF_DIR/yarn-site.xml
sed -i 's:YARN_LOCAL_DIR:'"$YARN_LOCAL_DIR"':g' $HADOOP_CONF_DIR/yarn-site.xml
sed -i 's:YARN_LOG_DIR:'"$YARN_LOG_DIR"':g' $HADOOP_CONF_DIR/yarn-site.xml
sed -i 's:HISTORY_SERVER:'"$NAMENODE"':g' $HADOOP_CONF_DIR/yarn-site.xml

rm -Rf $HADOOP_LOG_DIR; mkdir -p $HADOOP_LOG_DIR; 
rm -Rf $YARN_LOCAL_DIR; mkdir -p $YARN_LOCAL_DIR; 
rm -Rf $YARN_LOG_DIR; mkdir -p $YARN_LOG_DIR

cat $PBS_NODEFILE | sort | uniq | tail -n +2 > ${HADOOP_CONF_DIR}/workers
while read line
do
  for loc in $HADOOP_DATA_DIR $HADOOP_LOG_DIR $HADOOP_TMP_DIR $YARN_LOCAL_DIR $YARN_LOG_DIR
  do 
    cmd="rm -Rf $loc; mkdir -p $loc"
    ssh -tt $line $cmd </dev/null
  done
done < ${HADOOP_CONF_DIR}/workers

echo "Begin launching Hadoop cluster ..."
time ${HADOOP_HOME}/bin/hdfs --config ${HADOOP_CONF_DIR} namenode -format -force
set -x
time $HADOOP_ROOT/sbin/start-dfs.sh --config ${HADOOP_CONF_DIR}
time $HADOOP_ROOT/sbin/start-yarn.sh --config ${HADOOP_CONF_DIR}
echo "Waiting for datanodes to launch ..."
sleep 10
time ${HADOOP_HOME}/bin/hdfs --config ${HADOOP_CONF_DIR} dfsadmin -report