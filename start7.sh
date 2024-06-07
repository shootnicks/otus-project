#!/bin/bash
echo "---"
echo "Starting Zabbix"
echo "---"
docker compose -f docker-compose-3-Zabbix.yml up -d;
