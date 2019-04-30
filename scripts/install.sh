#!/bin/bash

# nginx
sudo apt-get update
sudo apt-get install nginx -y

# stackdriver
curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
sudo bash install-logging-agent.sh

# fluentd config for nginx
FILE="/etc/google-fluentd/config.d/nginx.conf"

/bin/cat <<EOM >$FILE
<source>
  @type tail
  format nginx
  path /var/log/nginx/access.log
  pos_file /var/lib/google-fluentd/pos/nginx-access.pos
  read_from_head true
  tag nginx-access
</source>
EOM

# reload stackdriver logging agent
sudo service google-fluentd reload
