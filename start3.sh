#!/bin/bash
echo "---"
echo "Set ip in file docker-compose-4-ELKB.yml"
echo "---"
host_ip=$(hostname -I | awk '{print $1}');
sed -i "s/host_ip/${host_ip}/g" /opt/otus-project/docker-compose-4-ELKB.yml;
echo "---"
echo 'Creating network "otus-net"'
echo "---"
docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/24 otus-net;
