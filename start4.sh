#!/bin/bash
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
