#!/bin/bash

pushd $HOME

if [ -d "persistent-hdfs" ]; then
  echo "Persistent HDFS seems to be installed. Exiting."
  return 0
fi

case "$HADOOP_MAJOR_VERSION" in
  1)
    wget http://d3kbcqa49mib13.cloudfront.net/hadoop-1.0.4.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-1.0.4.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-1.0.4/ persistent-hdfs/
    ;;
  2)
    wget http://d3kbcqa49mib13.cloudfront.net/hadoop-2.0.0-cdh4.2.0.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-2.0.0-cdh4.2.0/ persistent-hdfs/

    # Have single conf dir
    rm -rf $HOME/persistent-hdfs/etc/hadoop/
    ln -s $HOME/persistent-hdfs/conf $HOME/persistent-hdfs/etc/hadoop
    ;;

  *)
     echo "ERROR: Unknown Hadoop version"
     return -1
esac
cp $HOME/hadoop-native/* $HOME/persistent-hdfs/lib/native/
$HOME/spark-ec2/copy-dir $HOME/persistent-hdfs
popd
