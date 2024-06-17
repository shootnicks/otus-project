# otus-project


## Варианты установки:

### Мега упрощённая с предварительно установленным ПО (пакетами и Docker образами)


Запустите команду ниже и идите попейте кофе. :)

    curl -fsSL https://github.com/shootnicks/otus-project/raw/main/short_start.sh | sudo sh



### Мега упрощённая


Запустите команду ниже и идите попейте кофе. :)

    apt install curl mc nfs-common sudo -y
    curl -fsSL https://github.com/shootnicks/otus-project/raw/main/start.sh | sudo sh



## Дополнительные команды


Зайти в контейнер

    docker exec -it Nginx bash


Перезапустить контейнер

    docker-compose -f docker-compose-Nginx.yml restart


Посмотреть логи программы работающей в контейнере (работает не со всеми контейнерами)

    docker logs zabbix-server
