#!/bin/bash
echo "---"
echo "Starting Nginx"
echo "---"
docker compose -f docker-compose-5-Nginx.yml -d;
echo "---"
echo "Congratulations! Everything is running!"
echo "---"