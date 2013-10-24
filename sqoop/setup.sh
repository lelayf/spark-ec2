#!/bin/bash

pushd /root

export PATH=$PATH:/root/ephemeral-hdfs/bin

hadoop fs -copyToLocal s3n://viadeo-bi/sqoop-1.4.4.bin__hadoop-1.0.0.tar.gz sqoop-1.4.4.bin__hadoop-1.0.0.tar.gz
tar -xzf sqoop-1.4.4.bin__hadoop-1.0.0.tar.gz
mv sqoop-1.4.4.bin__hadoop-1.0.0 sqoop
rm sqoop-1.4.4.bin__hadoop-1.0.0.tar.gz

hadoop fs -copyToLocal s3n://viadeo-bi/mysql-connector-java-5.1.26.tar.gz mysql-connector-java-5.1.26.tar.gz
tar -xzf mysql-connector-java-5.1.26.tar.gz

cp mysql-connector-java-5.1.26/mysql-connector-java-5.1.26-bin.jar sqoop/lib/
rm -rf mysql-connector-java-5.1.26

hadoop fs -copyToLocal s3n://viadeo-bi/sqoop-site.xml sqoop-site.xml 
mv sqoop-site.xml sqoop/conf

cat >> /root/.bash_profile <<EOF 
export PATH=$PATH:/root/sqoop/bin
EOF

cat >> /root/sqoop/conf/sqoop-env.sh <<EOF 
export HADOOP_COMMON_HOME=/root/ephemeral-hdfs
export HADOOP_MAPRED_HOME=/root/mapreduce
EOF

. /root/.bash_profile

/root/spark-ec2/copy-dir /root/sqoop

ephemeral-hdfs/bin/stop-all.sh
ephemeral-hdfs/bin/start-all.sh

popd



