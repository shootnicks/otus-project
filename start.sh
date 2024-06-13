#!/bin/bash
cd /opt
echo "\e[1;33m---"
echo "Install Docker"
echo "---\e[1;m"
curl -fsSL https://get.docker.com | sudo sh



echo "\e[1;33m---"
echo "Clone project from Github"
echo "---\e[1;m"
cd /opt
git clone https://github.com/shootnicks/otus-project.git
cd /opt/otus-project



echo "\e[1;33m---"
echo "Set IP in file docker-compose-4-ELKB.yml"
echo "---\e[1;m"
host_ip=$(hostname -I | awk '{print $1}');
sed -i "s/host_ip/${host_ip}/g" /opt/otus-project/docker-compose-4-ELKB.yml;



echo "\e[1;33m---"
echo 'Creating network "otus-net"'
echo "---\e[1;m"
docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/24 otus-net;



echo "\e[1;33m---"
echo "Load docker images"
echo "---\e[1;m"
#curl -o docker_images.zip -L "https://hosting.n-dbc.ru/s/Eo9K3dQGmm9gWER/download";
#unzip docker_images.zip -d /opt/otus-project/docker_images;
#rm docker_images.zip;
mkdir -p docker_images;
mount -t nfs 192.168.1.202:/mnt/otus-project/docker_images/ ./docker_images;
docker load -i docker_images/nginx.tar;
docker load -i docker_images/httpd.tar;
docker load -i docker_images/mysql.tar;
docker load -i docker_images/zabbix-server-mysql.tar;
docker load -i docker_images/zabbix-web-nginx-mysql.tar;
docker load -i docker_images/zabbix-agent.tar;
docker load -i docker_images/ELKB/elasticsearch.8.13.4.tar;
docker load -i docker_images/ELKB/logstash.8.13.4.tar;
docker load -i docker_images/ELKB/kibana.8.13.4.tar;
docker load -i docker_images/ELKB/filebeat.8.13.4.tar;
umount ./docker_images;
rm -r docker_images;



echo "\e[1;33m---"
echo "Starting Apache2"
echo "---\e[1;m"
docker compose -f docker-compose-1-Apache2.yml up -d;



echo "\e[1;33m---"
echo "Starting MySQL"
echo "---\e[1;m"
#mkdir /opt/otus-project/mysql/mysql-source/scripts;
docker compose -f docker-compose-2-MySQL.yml up -d;



echo "\e[1;33m---"
echo "Check DB"
echo "---\e[1;m"
./zabbix/check_db.sh



echo "\e[1;33m---"
echo "Restore zabbix DB"
echo "---\e[1;m"
./zabbix/restore_zabbix.sh



echo "\e[1;33m---"
echo "Starting Zabbix"
echo "---\e[1;m"
docker compose -f docker-compose-3-Zabbix.yml up -d;



echo "\e[1;33m---"
echo "Starting ELKB"
echo "---\e[1;m"
mkdir /opt/otus-project/ELKB/elasticsearch/;
mkdir /opt/otus-project/ELKB/elasticsearch/data/;
mkdir /opt/otus-project/ELKB/kibana/;
mkdir /opt/otus-project/ELKB/certs/;
docker compose -f docker-compose-4-ELKB.yml up -d;



echo "\e[1;33m---"
echo "Starting Nginx"
echo "---\e[1;m"
docker compose -f docker-compose-5-Nginx.yml up -d;



echo "\e[1;32m---"
echo "Congratulations! Everything is running!"
echo "---\e[1;m"



echo "\e[1;35mPlease add the CA certificate to your computer.:"
echo ""
cat /opt/otus-project/ELKB/certs/ca/ca.crt
echo "\e[1;m"
