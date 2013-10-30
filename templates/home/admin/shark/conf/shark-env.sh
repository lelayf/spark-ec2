#!/usr/bin/env bash

# Set Spark's memory per machine -- you might want to increase this
export SHARK_MASTER_MEM=1g

# Java options
SPARK_JAVA_OPTS+="-Dspark.kryoserializer.buffer.mb=10 "
#SPARK_JAVA_OPTS+="-verbose:gc -XX:-PrintGCDetails -XX:+PrintGCTimeStamps "
export SPARK_JAVA_OPTS

export HIVE_HOME="$HOME/hive-0.9.0-bin"
export HADOOP_HOME=$HOME/ephemeral-hdfs
export HIVE_CONF_DIR=$HOME/ephemeral-hdfs/conf

export MASTER=`cat $HOME/spark-ec2/cluster-url`
export SPARK_HOME=$HOME/spark

source $SPARK_HOME/conf/spark-env.sh
