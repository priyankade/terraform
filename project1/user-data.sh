#!/bin/bash

########################################
##### USE THIS WITH AMAZON LINUX 2 #####
########################################

# get admin privileges
sudo su

#ssm agent
sudo yum install -y https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl start amazon-ssm-agent

# install httpd (Linux 2 version)
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "Hello World from $(hostname -f)" > /var/www/html/index.html