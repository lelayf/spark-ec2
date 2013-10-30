#!/bin/bash

# Setup persistent-hdfs
sudo mkdir -p /mnt/persistent-hdfs/logs

if [[ -e /vol/persistent-hdfs ]] ; then
  sudo chmod -R 755 /vol/persistent-hdfs
fi
