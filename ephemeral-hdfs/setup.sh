#!/bin/bash

EPHEMERAL_HDFS=$HOME/ephemeral-hdfs

# Set hdfs url to make it easier
HDFS_URL="hdfs://$PUBLIC_DNS:9000"
echo "export HDFS_URL=$HDFS_URL" >> ~/.bash_profile

pushd $HOME/spark-ec2/ephemeral-hdfs
source ./setup-slave.sh

for node in $SLAVES $OTHER_MASTERS; do
  echo $node
  ssh -t -t $SSH_OPTS $LOGNAME@$node "$HOME/spark-ec2/ephemeral-hdfs/setup-slave.sh" & sleep 0.3
done
wait

$HOME/spark-ec2/copy-dir $EPHEMERAL_HDFS/conf

NAMENODE_DIR=/mnt/ephemeral-hdfs/dfs/name

if [ -f "$NAMENODE_DIR/current/VERSION" ] && [ -f "$NAMENODE_DIR/current/fsimage" ]; then
  echo "Hadoop namenode appears to be formatted: skipping"
else
  echo "Formatting ephemeral HDFS namenode..."
  sudo $EPHEMERAL_HDFS/bin/hadoop namenode -format
fi

echo "Starting ephemeral HDFS..."
# This is different depending on version. Simple hack: just try both.
sudo $EPHEMERAL_HDFS/sbin/start-dfs.sh
sudo $EPHEMERAL_HDFS/bin/start-dfs.sh

popd
