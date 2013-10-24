#!/bin/bash

pushd /root

export PATH=$PATH:/root/ephemeral-hdfs/bin

hadoop fs -copyToLocal s3n://viadeo-bi/sqoop-1.4.4.bin__hadoop-1.0.0.tar.gz sqoop-1.4.4.bin__hadoop-1.0.0.tar.gz
tar -xzf sqoop-1.4.4.bin__hadoop-1.0.0.tar.gz
mv sqoop-1.4.4.bin__hadoop-1.0.0 sqoop

hadoop fs -copyToLocal s3n://viadeo-bi/mysql-connector-java-5.1.26.tar.gz mysql-connector-java-5.1.26.tar.gz
tar -xzf mysql-connector-java-5.1.26.tar.gz

cp mysql-connector-java-5.1.26/mysql-connector-java-5.1.26-bin.jar sqoop/lib/

hadoop fs -copyToLocal s3n://viadeo-bi/sqoop-site.xml sqoop-site.xml 
cp sqoop-site.xml sqoop/conf

cat >> ~/.bashrc <<EOF 
export PATH=$PATH:/root/sqoop/bin
EOF

. ~/.bashrc

/root/spark-ec2/copy-dir /root/sqoop

popd



