#!/bin/bash

if [[ ! -e /mnt/ephemeral-hdfs/dfs/name ]] ; then
  mkdir -p /mnt/ephemeral-hdfs/dfs/name
  mkdir -p /mnt/ephemeral-hdfs/dfs/data
  chown -R hdfs:hdfs /mnt/ephemeral-hdfs/
  chmod 700 /mnt/ephemeral-hdfs/dfs/name /mnt/ephemeral-hdfs/dfs/data 
fi
