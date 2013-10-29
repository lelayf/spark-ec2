#!/bin/bash

# Make sure we are in the spark-ec2 directory
cd $HOME/spark-ec2

source ec2-variables.sh

# Set hostname based on EC2 private DNS name, so that it is set correctly
# even if the instance is restarted with a different private DNS name
PRIVATE_DNS=`wget -q -O - http://169.254.169.254/latest/meta-data/local-hostname`
sudo hostname $PRIVATE_DNS
sudo echo $PRIVATE_DNS > /etc/hostname
HOSTNAME=$PRIVATE_DNS  # Fix the bash built-in hostname variable too

AZ=`wget -q -O - http://169.254.169.254/latest/meta-data/placement/availability-zone`
IPV4=`wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4`
sudo cat >> /etc/hosts <<EOF
$IPV4 $PRIVATE_DNS $PRIVATE_DNS.$AZ.compute.internal
EOF

if [[ -e private_master ]]; then
  sudo cat private_master >> /etc/hosts
fi

echo "Setting up slave on `hostname`..."

# Mount options to use for ext3 and xfs disks (the ephemeral disks
# are ext3, but we use xfs for EBS volumes to format them faster)
XFS_MOUNT_OPTS="defaults,noatime,nodiratime,allocsize=8m"

# Format and mount EBS volume (/dev/sdv) as /vol if the device exists
if [[ -e /dev/sdv ]]; then
  # Check if /dev/sdv is already formatted
  if ! blkid /dev/sdv; then
    sudo mkdir /vol
    if sudo mkfs.xfs -q /dev/sdv; then
      sudo mount -o $XFS_MOUNT_OPTS /dev/sdv /vol
      sudo chmod -R a+w /vol
    else
      # mkfs.xfs is not installed on this machine or has failed;
      # delete /vol so that the user doesn't think we successfully
      # mounted the EBS volume
      sudo rmdir /vol
    fi
  else
    # EBS volume is already formatted. Mount it if its not mounted yet.
    if ! grep -qs '/vol' /proc/mounts; then
      sudo mkdir /vol
      sudo mount -o $XFS_MOUNT_OPTS /dev/sdv /vol
      sudo chmod -R a+w /vol
    fi
  fi
fi

# Make data dirs writable by non-root users, such as CDH's hadoop user
sudo chmod -R a+w /mnt*

# Remove ~/.ssh/known_hosts because it gets polluted as you start/stop many
# clusters (new machines tend to come up under old hostnames)
rm -f $HOME/.ssh/known_hosts

# Create swap space on /mnt
$HOME/spark-ec2/create-swap.sh $SWAP_MB

# Allow memory to be over committed. Helps in pyspark where we fork
sudo echo 1 > /proc/sys/vm/overcommit_memory

# Add github to known hosts to get git@github.com clone to work
# TODO(shivaram): Avoid duplicate entries ?
cat $HOME/spark-ec2/github.hostkey >> $HOME/.ssh/known_hosts
