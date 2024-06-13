#!/bin/bash
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
# Имя контейнера Docker
Container=mysql-source
# Строка, которую нужно найти в логах
SEARCH_STRING="port: 3306  MySQL Community Server - GPL."
# Интервал проверки в секундах
CHECK_INTERVAL=3
# Функция для проверки логов Docker
check_docker_logs() {
        docker logs "$Container" 2>&1 | grep -q "$SEARCH_STRING"
    return $?
}
# Функция для обновления строки на экране
update_line() {
    local message=$1
    echo -ne "\r$message"
}
# Функция для скрытия курсора
hide_cursor() {
#    echo -ne "\e[?25l"
    echo "\e[?25l"
}
# Функция для отображения курсора
show_cursor() {
    echo -ne "\e[?25h"
}
hide_cursor
i=""
# Основной цикл проверки
while true; do
    if check_docker_logs; then
        echo "СУБД инициализирована."
        break
    else
        update_line "Идёт инициализация СУБД$i"
        sleep $CHECK_INTERVAL
        i=$i".";
        if [ ${#i} -eq 4 ]; then
                i=""
        fi
    fi
done
# Перенос строки после завершения цикла
echo



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
