#!/bin/bash

sudo apt update
sudo apt install -y curl unzip supervisor
sudo curl -Lo /tmp/awsredrive.core.linux.zip https://github.com/nickntg/awsredrive.core/releases/download/1.0/awsredrive.core.linux.zip
sudo mkdir -p /opt/awsredrive/non-ansible-releases
sudo unzip /tmp/awsredrive.core.linux.zip -d /opt/awsredrive/non-ansible-releases
sudo ln -sf /opt/awsredrive/non-ansible-releases /opt/awsredrive/current
sudo chmod ug+x /opt/awsredrive/non-ansible-releases/AWSRedrive.console

sudo cat <<EOF > /etc/supervisor/conf.d/awsredrive.conf
[program:awsredrive]
command=/opt/awsredrive/current/AWSRedrive.console
directory=/opt/awsredrive/current/
numprocs=1
startsecs=5
process_name=%(program_name)s%(process_num)s
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile= /var/log/supervisor/awsredrive.log
stdout_logfile_maxbytes=800MB
stdout_logfile_backups=2
stdout_events_enabled=false
stderr_logfile=/var/log/supervisor/awsredrive.err
stderr_logfile_maxbytes=800MB
stderr_logfile_backups=2
EOF


sudo cat << EOF > /opt/awsredrive/current/config.json
[
  {
    "Alias": "#1",
    "QueueUrl": "https://sqs.eu-west-1.amazonaws.com/accountid/inputqueue1",
    "RedriveUrl": "http://nohost.com/",
    "Region": "eu-west-1",
    "Active": true,
    "Timeout": 10000
  }
]
EOF

sudo systemctl restart supervisor.service
