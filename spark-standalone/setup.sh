#!/bin/bash

# Copy the slaves to spark conf
cp $HOME/spark-ec2/slaves $HOME/spark/conf/
$HOME/spark-ec2/copy-dir $HOME/spark/conf

# Set cluster-url to standalone master
echo "spark://""`cat $HOME/spark-ec2/masters`"":7077" > $HOME/spark-ec2/cluster-url
$HOME/spark-ec2/copy-dir $HOME/spark-ec2

# The Spark master seems to take time to start and workers crash if
# they start before the master. So start the master first, sleep and then start
# workers.

# Stop anything that is running
$HOME/spark/bin/stop-all.sh

sleep 2

# Start Master
$HOME/spark/bin/start-master.sh

# Pause
sleep 20

# Start Workers
$HOME/spark/bin/start-slaves.sh
