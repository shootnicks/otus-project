#!/bin/bash
echo "---"
echo "Starting MySQL"
echo "---"
docker compose -f docker-compose-2-MySQL.yml up -d;
