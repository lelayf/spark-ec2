#!/bin/bash

# Setup ephemeral-hdfs
sudo mkdir -p /mnt/ephemeral-hdfs/logs
sudo mkdir -p /mnt/hadoop-logs

# Create Hadoop and HDFS directories in a given parent directory
# (for example /mnt, /mnt2, and so on)
function create_hadoop_dirs {
  location=$1
  if [[ -e $location ]]; then
    sudo mkdir -p $location/ephemeral-hdfs $location/hadoop/tmp
    sudo chmod -R 755 $location/ephemeral-hdfs
    sudo mkdir -p $location/hadoop/mrlocal $location/hadoop/mrlocal2
  fi
}

# Set up Hadoop and Mesos directories in /mnt
create_hadoop_dirs /mnt
create_hadoop_dirs /mnt2
create_hadoop_dirs /mnt3
create_hadoop_dirs /mnt4
