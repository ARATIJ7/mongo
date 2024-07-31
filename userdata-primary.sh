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

# Wait for MongoDB to start
sleep 15

# Initialize the replica set (replace with actual IPs)
mongo --eval 'rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "PRIMARY_NODE_PRIVATE_IP:27017" },
    { _id: 1, host: "REPLICA1_NODE_PRIVATE_IP:27017" },
    { _id: 2, host: "REPLICA2_NODE_PRIVATE_IP:27017" }
  ]
})'
