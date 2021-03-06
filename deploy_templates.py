#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import with_statement

import os
import sys

# Deploy the configuration file templates in the spark-ec2/templates directory
# to the root filesystem, substituting variables such as the master hostname,
# ZooKeeper URL, etc as read from the environment.

# Find system memory in KB and compute Spark's default limit from that
mem_command = "cat /proc/meminfo | grep MemTotal | awk '{print $2}'"

master_ram_kb = int(
  os.popen(mem_command).read().strip())
# This is the master's memory. Try to find slave's memory as well
first_slave = os.popen("cat $HOME/spark-ec2/slaves | head -1").read().strip()

slave_mem_command = "ssh -t -o StrictHostKeyChecking=no %s %s" %\
        (first_slave, mem_command)
slave_ram_kb = int(os.popen(slave_mem_command).read().strip())

system_ram_kb = min(slave_ram_kb, master_ram_kb)

system_ram_mb = system_ram_kb / 1024
# Leave some RAM for the OS, Hadoop daemons, and system caches
if system_ram_mb > 100*1024:
  spark_mb = system_ram_mb - 15 * 1024 # Leave 15 GB RAM
elif system_ram_mb > 60*1024:
  spark_mb = system_ram_mb - 10 * 1024 # Leave 10 GB RAM
elif system_ram_mb > 40*1024:
  spark_mb = system_ram_mb - 6 * 1024 # Leave 6 GB RAM
elif system_ram_mb > 20*1024:
  spark_mb = system_ram_mb - 3 * 1024 # Leave 3 GB RAM
elif system_ram_mb > 10*1024:
  spark_mb = system_ram_mb - 2 * 1024 # Leave 2 GB RAM
else:
  spark_mb = max(512, system_ram_mb - 1300) # Leave 1.3 GB RAM

template_vars = {
  "master_list": os.getenv("MASTERS"),
  "active_master": os.getenv("MASTERS").split("\n")[0],
  "slave_list": os.getenv("SLAVES"),
  "hdfs_data_dirs": os.getenv("HDFS_DATA_DIRS"),
  "mapred_local_dirs": os.getenv("MAPRED_LOCAL_DIRS"),
  "spark_local_dirs": os.getenv("SPARK_LOCAL_DIRS"),
  "default_spark_mem": "%dm" % spark_mb,
  "spark_version": os.getenv("SPARK_VERSION"),
  "shark_version": os.getenv("SHARK_VERSION"),
  "hadoop_major_version": os.getenv("HADOOP_MAJOR_VERSION"),
  "scala_home": os.getenv("SCALA_HOME"),
  "java_home": os.getenv("JAVA_HOME"),
  "awssak" : os.getenv("AWSSAK"),
  "awsakid" : os.getenv("AWSAKID")
}

template_dir= os.getenv("HOME") + "/spark-ec2/templates"

for path, dirs, files in os.walk(template_dir):
  if path.find(".svn") == -1:
    dest_dir = os.path.join('/', path[len(template_dir):])
    if not os.path.exists(dest_dir):
      os.makedirs(dest_dir)
    for filename in files:
      if filename[0] not in '#.~' and filename[-1] != '~':
        dest_file = os.path.join(dest_dir, filename)
        with open(os.path.join(path, filename)) as src:
          with open(dest_file, "w") as dest:
            print "Configuring " + dest_file
            text = src.read()
            for key in template_vars:
              text = text.replace("{{" + key + "}}", template_vars[key])
            dest.write(text)
            dest.close()
