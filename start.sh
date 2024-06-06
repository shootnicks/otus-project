#!/bin/bash
cd /opt
#echo "---"
#echo "Install Docker"
#echo "---"
curl -fsSL https://get.docker.com | sudo sh
#echo "---"
#echo "Settings vars"
#echo "---"
#git config --global user.email "pg.andriyanov@gmail.com";
#git config --global user.name "Andriyanov Pavel";
echo "---"
echo "Clone project from Github"
echo "---"
git clone git@github.com:shootnicks/otus-project.git
cd /opt/otus-project
echo "---"
echo "Set ip in file docker-compose-4-ELKB.yml"
echo "---"
host_ip=$(hostname -I | awk '{print $1}');
sed -i "s/host_ip/${host_ip}/g" /opt/otus-project/docker-compose-4-ELKB.yml;
echo "---"
echo 'Creating network "otus-net"'
echo "---"
docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/24 otus-net;
echo "---"
echo "Load docker images"
echo "---"
curl -o docker_images.zip -L "https://hosting.n-dbc.ru/s/Eo9K3dQGmm9gWER/download";
unzip docker_images.zip -d /opt/otus-project/docker_images;
rm docker_images.zip;
docker load -i docker_images/nginx.tar;
rm docker_images/nginx.tar;
docker load -i docker_images/httpd.tar;
rm docker_images/httpd.tar;
docker load -i docker_images/mysql.tar;
rm docker_images/mysql.tar;
docker load -i docker_images/zabbix-server-mysql.tar;
rm docker_images/zabbix-server-mysql.tar;
docker load -i docker_images/zabbix-web-nginx-mysql.tar;
rm docker_images/zabbix-web-nginx-mysql.tar;
docker load -i docker_images/zabbix-agent.tar;
rm docker_images/zabbix-agent.tar;
docker load -i docker_images/ELKB/elasticsearch.8.13.4.tar;
rm docker_images/ELKB/elasticsearch.8.13.4.tar;
docker load -i docker_images/ELKB/logstash.8.13.4.tar;
rm docker_images/ELKB/logstash.8.13.4.tar;
docker load -i docker_images/ELKB/kibana.8.13.4.tar;
rm docker_images/ELKB/kibana.8.13.4.tar;
docker load -i docker_images/ELKB/filebeat.8.13.4.tar;
rm docker_images/ELKB/filebeat.8.13.4.tar;
rm -r docker_images;
echo "---"
echo "Starting Apache2"
echo "---"
docker compose -f docker-compose-1-Apache2.yml up -d;
echo "---"
echo "Starting MySQL"
echo "---"
docker compose -f docker-compose-2-MySQL.yml up -d;
echo "---"
echo "Starting Zabbix"
echo "---"
docker compose -f docker-compose-3-Zabbix.yml -d;
echo "---"
echo "Starting ELKB"
echo "---"
docker compose -f docker-compose-4-ELKB.yml -d;
echo "---"
echo "Starting Nginx"
echo "---"
docker compose -f docker-compose-5-Nginx.yml -d;
echo "---"
echo "Congratulations! Everything is running!"
echo "---"
