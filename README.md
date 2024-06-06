# otus-project


## Мега упрощённая


Запустите команду ниже и идите попейте кофе. :)

    apt install curl mc -y
    curl -fsSL https://github.com/shootnicks/otus-project/raw/main/start.sh | sudo sh


## Основная инструкция


Переходим в папку /opt

    cd /opt


Копируем свои файлы из репозитория на github.com

    git clone git@github.com:shootnicks/otus-project.git


Заходим в папку с нашим проектом

    cd otus-project


Нужно создать сеть для нажего проекта


    docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/24 otus-net


Запускаем контейнер c Nginx frontend


    docker compose -f docker-compose-Nginx.yml up -d


Запускаем контейнер c Apache2 backend


    docker compose -f docker-compose-Apache2.yml up -d


Запускаем контейнер c MySQL


    docker compose -f docker-compose-MySQL.yml up -d


Запускаем контейнер c Zabbix


    docker compose -f docker-compose-Zabbix.yml up -d


## Дополнительные команды


Зайти в контейнер

    docker exec -it Nginx bash


Перезапустить контейнер

    docker-compose -f docker-compose-Nginx.yml restart


Посмотреть логи программы работающей в контейнере (работает не со всеми контейнерами)

    docker logs zabbix-server
