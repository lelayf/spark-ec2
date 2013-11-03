#!/bin/bash

pushd /root/spark-ec2/hadoop


/root/spark-ec2/copy-dir /etc/hadoop/conf

if [[ -e /vol/persistent-hdfs ]] ; then
  chmod -R 755 /vol/persistent-hdfs
fi

if [[ ! -e /vol/persistent-hdfs/dfs/name ]] ; then
  echo "Formatting persistent HDFS namenode..."
  hadoop namenode -format
fi

/etc/init.d/hadoop-hdfs-namenode start
/etc/init.d/hadoop-yarn-resourcemanager start
/etc/init.d/hadoop-hdfs-datanode start
/etc/init.d/hadoop-yarn-nodemanager start

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t $SSH_OPTS root@$node "/root/spark-ec2/hadoop/setup-slave.sh" & sleep 0.3
done
wait

echo "Persistent HDFS installed, won't start by default..."

popd
