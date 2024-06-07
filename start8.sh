#!/bin/bash
echo "---"
echo "Starting ELKB"
echo "---"
mkdir /opt/otus-project/ELKB/elasticsearch/;
mkdir /opt/otus-project/ELKB/elasticsearch/data/;
mkdir /opt/otus-project/ELKB/kibana/;
mkdir /opt/otus-project/ELKB/certs/;
docker compose -f docker-compose-4-ELKB.yml up -d;
