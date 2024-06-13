#!/bin/bash

Container=mysql-source;
DbName=zabbix;
User=root;
Password=example;
Work_dir=/opt/otus-project/zabbix

mkdir -p $Work_dir/backup_zabbix
mount -t nfs 192.168.1.202:/mnt/otus-project/backup_zabbix $Work_dir/backup_zabbix

# Функция для обновления строки на экране
update_line() {
    local message="$1"
    echo -ne "\r\033[K$message"
}

# Функция для скрытия курсора
hide_cursor() {
    echo -ne "\e[?25l"
}

# Функция для отображения курсора
show_cursor() {
    echo -ne "\e[?25h"
}

hide_cursor

echo -e 'Target DBMS =\e[1;31m '$Container'\e[1;m';
echo -e 'Databese name =\e[1;31m '$DbName'\e[1;m';
i=""

# Ищем последний сделанный бэкап в папке с бэкапами.
last_backup_file=`ls -1 $Work_dir/backup_zabbix | grep "backup_" | sort | tail -n 1`;
# Создаём временную папку для хранения распокованных файлов.
mkdir -p $Work_dir/tempo_for_restore;
# Распаковываем файлы дампа из последнего сделанного бэкапа.
tar -xf $Work_dir/backup_zabbix/$last_backup_file -C $Work_dir/tempo_for_restore/;

## Создаём базу данных.
#echo "CREATE DATABASE $DbName;" | docker exec -e MYSQL_PWD=$Password -i $Container /usr/bin/mysql -u $User

# Перебор всех файлов во всех вложенных папках
find "$Work_dir/tempo_for_restore" -type f | while read -r file; do
	cat "$file" | docker exec -e MYSQL_PWD=$Password -i $Container /usr/bin/mysql -u $User $DbName
	update_line "The restore is in progress. Please wait$i"
	i=$i".";
	if [ ${#i} -eq 4 ]; then
		i=""
	fi
done

# Перенос строки после завершения цикла
echo

# Удаляем временную папку для хранения распокованных файлов.
rm -r $Work_dir/tempo_for_restore

umount $Work_dir/backup_zabbix
rm -r $Work_dir/backup_zabbix

echo -e '\e[1;32mCongratulations, the restore is done!\e[1;m';

show_cursor

unset MYSQL_PWD;
