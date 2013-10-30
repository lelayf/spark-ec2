#!/bin/bash

$HOME/spark-ec2/copy-dir /etc/ganglia/

# Start gmond everywhere
sudo etc/init.d/gmond restart

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t -t $SSH_OPTS $LOGNAME@$node "sudo /etc/init.d/gmond restart"
done

# gmeta needs rrds to be owned by nobody
sudo chown -R nobody /var/lib/ganglia/rrds
# cluster-wide aggregates only show up with this. TODO: Fix this cleanly ?
sudo ln -s /usr/share/ganglia/conf/default.json /var/lib/ganglia/conf/

sudo /etc/init.d/gmetad restart

# Start http server to serve ganglia
sudo /etc/init.d/httpd restart
