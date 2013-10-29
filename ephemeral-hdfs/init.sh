#!/bin/bash

pushd $HOME

if [ -d "ephemeral-hdfs" ]; then
  echo "Ephemeral HDFS seems to be installed. Exiting."
  return 0
fi

case "$HADOOP_MAJOR_VERSION" in
  1)
    wget http://d3kbcqa49mib13.cloudfront.net/hadoop-1.0.4.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-1.0.4.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-1.0.4/ ephemeral-hdfs/
    sed -i 's/-jvm server/-server/g' $HOME/ephemeral-hdfs/bin/hadoop
    ;;
  2) 
    wget http://d3kbcqa49mib13.cloudfront.net/hadoop-2.0.0-cdh4.2.0.tar.gz  
    echo "Unpacking Hadoop"
    tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-2.0.0-cdh4.2.0/ ephemeral-hdfs/

    # Have single conf dir
    rm -rf $HOME/ephemeral-hdfs/etc/hadoop/
    ln -s $HOME/ephemeral-hdfs/conf $HOME/ephemeral-hdfs/etc/hadoop
    ;;

  *)
     echo "ERROR: Unknown Hadoop version"
     return -1
esac
cp $HOME/hadoop-native/* ephemeral-hdfs/lib/native/
$HOME/spark-ec2/copy-dir $HOME/ephemeral-hdfs
popd
