#!/bin/bash

pushd /root/spark-ec2/hadoop

source ec2-variables.sh

/root/spark-ec2/copy-dir /etc/hadoop/conf

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t $SSH_OPTS root@$node "/root/spark-ec2/hadoop/createdirs.sh" & sleep 0.3
done
wait

echo "Formatting persistent HDFS namenode..."
sudo su -l hdfs -c "hadoop namenode -format -nonInteractive"
wait

/etc/init.d/hadoop-hdfs-namenode start
wait
for node in $SLAVES $MASTERS; do
  ssh -t $SSH_OPTS root@$node "/root/spark-ec2/hadoop/start-datanode.sh" & sleep 0.3
done
wait

/etc/init.d/hadoop-yarn-resourcemanager start
wait
for node in $SLAVES $MASTERS; do
  ssh -t $SSH_OPTS root@$node "/root/spark-ec2/hadoop/start-nodemanager.sh" & sleep 0.3
done
wait

popd
