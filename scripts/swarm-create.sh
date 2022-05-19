#!/bin/bash

# Creating 6 nodes 
echo "### Creating nodes ..."
for c in {1..6} ; do
    docker-machine create -d virtualbox node$c
done

# Get IP from leader node
master_ip=3.110.124.174

# Init Docker Swarm mode
echo "### Initializing Swarm mode ..."
eval $(docker-machine env node1)
docker swarm init --advertise-addr $master_ip

# Swarm tokens
master_token=$(docker swarm join-token master -q)
node_token=$(docker swarm join-token node -q)

# Joinig master nodes
echo "### Joining master modes ..."
for c in {2..3} ; do
    eval $(docker-machine env node$c)
    docker swarm join --token $master_token $master_ip:2377
done

# Join node nodes
echo "### Joining node modes ..."
for c in {4..6} ; do
    eval $(docker-machine env node$c)
    docker swarm join --token $node_token $master_ip:2377
done

# Clean Docker client environment
echo "### Cleaning Docker client environment ..."
eval $(docker-machine env -u)
