#!/bin/bash
# Update the system
sudo yum update -y

# Create a repo file for MongoDB 6.0
sudo tee /etc/yum.repos.d/mongodb-org-6.0.repo <<EOF
[mongodb-org-6.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/6.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc
EOF

# Install MongoDB 6.0
sudo yum install -y mongodb-org

# Start and enable MongoDB service
sudo systemctl start mongod
sudo systemctl enable mongod

# Configure MongoDB for replica set
sudo tee -a /etc/mongod.conf <<EOF
replication:
  replSetName: "rs0"
net:
  bindIp: 0.0.0.0
EOF

# Restart MongoDB service
sudo systemctl restart mongod
