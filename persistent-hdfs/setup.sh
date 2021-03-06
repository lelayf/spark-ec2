#!/bin/bash

PERSISTENT_HDFS=$HOME/persistent-hdfs

pushd $HOME/spark-ec2/persistent-hdfs
source ./setup-slave.sh

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t $SSH_OPTS $LOGNAME@$node "$HOME/spark-ec2/persistent-hdfs/setup-slave.sh" & sleep 0.3
done
wait

$HOME/spark-ec2/copy-dir $PERSISTENT_HDFS/conf

if [[ ! -e /vol/persistent-hdfs/dfs/name ]] ; then
  echo "Formatting persistent HDFS namenode..."
  sudo $PERSISTENT_HDFS/bin/hadoop namenode -format
fi

echo "Persistent HDFS installed, won't start by default..."

popd
