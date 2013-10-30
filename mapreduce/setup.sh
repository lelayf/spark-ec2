#!/bin/bash
MAPREDUCE=$HOME/mapreduce

sudo mkdir -p /mnt/mapreduce/logs
for node in $SLAVES $OTHER_MASTERS; do
  ssh -t $SSH_OPTS $LOGNAME@$node "sudo mkdir -p /mnt/mapreduce/logs && sudo chown hadoop:hadoop /mnt/mapreduce/logs && sudo chown hadoop:hadoop /mnt/mapreduce" & sleep 0.3
done
wait

sudo chown hadoop:hadoop /mnt/mapreduce -R
$HOME/spark-ec2/copy-dir $MAPREDUCE/conf
