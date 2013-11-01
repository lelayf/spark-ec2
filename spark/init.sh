#!/bin/bash

pushd /root

if [ -d "spark" ]; then
  echo "Spark seems to be installed. Exiting."
  return 0
fi

# Github tag:
if [[ "$SPARK_VERSION" == *\|* ]]
then
  mkdir spark
  pushd spark
  git init
  repo=`python -c "print '$SPARK_VERSION'.split('|')[0]"` 
  git_hash=`python -c "print '$SPARK_VERSION'.split('|')[1]"`
  git remote add origin $repo
  git fetch origin
  git checkout $git_hash
  sbt/sbt clean assembly
  sbt/sbt publish-local
  popd

# Pre-packaged spark version:
else 
  case "$SPARK_VERSION" in
    0.7.3)
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://d3kbcqa49mib13.cloudfront.net/spark-0.7.3-prebuilt-hadoop1.tgz
      else
        wget http://d3kbcqa49mib13.cloudfront.net/spark-0.7.3-prebuilt-cdh4.tgz
      fi
      ;;    
    0.8.0)
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://d3kbcqa49mib13.cloudfront.net/spark-0.8.0-incubating-bin-hadoop1.tgz
      else
        wget http://dzu9up16gax83.cloudfront.net/download/spark-0.8.0-incubating-hadoop-2.0.0-cdh4.1.2.tar.gz
        #wget http://d3kbcqa49mib13.cloudfront.net/spark-0.8.0-incubating-bin-cdh4.tgz
      fi
      ;;    
    *)
      echo "ERROR: Unknown Spark version"
      return -1
  esac

  echo "Unpacking Spark"
  tar xvzf spark-*gz > /tmp/spark-ec2_spark.log
  rm spark-*gz
  mv `ls -d spark-* | grep -v ec2` spark
fi

popd
