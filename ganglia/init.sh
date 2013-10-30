#!/bin/bash

# NOTE: Remove all rrds which might be around from an earlier run
sudo rm -rf /var/lib/ganglia/rrds/*
sudo rm -rf /mnt/ganglia/rrds/*

# Symlink /var/lib/ganglia/rrds to /mnt/ganglia/rrds
sudo rmdir /var/lib/ganglia/rrds
sudo ln -s /mnt/ganglia/rrds /var/lib/ganglia/rrds

# Make sure rrd storage directory has right permissions
sudo useradd -g nobody nobody -s /bin/false
sudo mkdir -p /mnt/ganglia/rrds
sudo chown -R nobody:nobody /mnt/ganglia/rrds

# Install ganglia
# TODO: Remove this once the AMI has ganglia by default

#GANGLIA_PACKAGES="ganglia ganglia-web ganglia-gmond ganglia-gmetad"
#GANGLIA_PACKAGES="ganglia-monitor ganglia-webfrontend gmetad"
#if ! rpm --quiet -q $GANGLIA_PACKAGES; then
#  yum install -q -y $GANGLIA_PACKAGES;
#fi
#for node in $SLAVES $OTHER_MASTERS; do
#  ssh -t -t $SSH_OPTS $LOGNAME@$node "if ! rpm --quiet -q $GANGLIA_PACKAGES; then yum install -q -y $GANGLIA_PACKAGES; fi" & sleep 0.3
#done
#wait
