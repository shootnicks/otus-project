# otus-project


Переходим в папку /opt

    cd /opt


Копируем свои файлы из репозитория на github.com

    git clone git@github.com:shootnicks/otus-project.git


Заходим в папку с нашим проектом

    cd otus-project


Запускаем контейнер c Nginx frontend


    docker compose -f docker-compose-Nginx.yml up -d


Запускаем контейнер c Apache2 backend


    docker compose -f docker-compose-Apache2.yml up -d






Заходим в него

    docker exec -it smarthomeNode-red bash


Устанавливаем пакеты для узлов

    cd /data
    npm install --unsafe-perm --no-update-notifier --no-fund --only=production


Выходим из запущенного контейнера

    exit


Перезапускам контейнер

    docker-compose -f docker-compose-Node-red.yml restart
