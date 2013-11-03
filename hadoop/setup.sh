#!/bin/bash

pushd /root/spark-ec2/hadoop


/root/spark-ec2/copy-dir /etc/hadoop/conf

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t $SSH_OPTS root@$node "/root/spark-ec2/hadoop/createdirs.sh" & sleep 0.3
done
wait

echo "Formatting persistent HDFS namenode..."
su - hdfs
hadoop namenode -format -force -nonInteractive
exit

/etc/init.d/hadoop-hdfs-namenode start
for node in $SLAVES $OTHER_MASTERS; do
  ssh -t $SSH_OPTS root@$node "/root/spark-ec2/hadoop/start-datanode.sh" & sleep 0.3
done
wait

/etc/init.d/hadoop-yarn-resourcemanager start
for node in $SLAVES $OTHER_MASTERS; do
  ssh -t $SSH_OPTS root@$node "/root/spark-ec2/hadoop/start-nodemanager.sh" & sleep 0.3
done
wait

popd
