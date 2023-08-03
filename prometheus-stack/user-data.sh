#!/bin/bash

########################################
##### USE THIS WITH UBUNTU #####
########################################

# get admin privileges
sudo su

#ssm agent
# sudo yum install -y https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm
# sudo systemctl start amazon-ssm-agent

# install httpd (Ubuntu)
sudo apt update
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl restart apache2
echo "Hello World from $(hostname -f)" > /var/www/html/index.html