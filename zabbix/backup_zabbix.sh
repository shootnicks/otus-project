#!/bin/bash

Container=mysql-replica;
DbName=zabbix;
User=root;
Password=example;
#export MYSQL_PWD=example;
#export MYSQL_PWD=$Password;
DATE=`date +"%Y-%m-%d_%Hh-%Mm"`;
DIR=tempo_backup_$DbName"_"$DATE;
FILE=backup_$DbName"_"$DATE".tar.gz"

mkdir $DIR;

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

echo -e 'Source DBMS =\e[1;31m '$Container'\e[1;m';
echo -e 'Databese name =\e[1;31m '$DbName'\e[1;m';
i=""

#for TABLE_NAME in `docker exec $Container mysql -u$User -p$Password --skip-column-names -e "SHOW TABLES FROM "$DbName`;
for TABLE_NAME in `docker exec -e MYSQL_PWD=$Password $Container mysql -u$User --skip-column-names -e "SHOW TABLES FROM "$DbName`;
	do
#		docker exec $Container /usr/bin/mysqldump -u $User --password=$Password --add-drop-table --add-locks --create-options --disable-keys --extended-insert --single-transaction --quick --set-charset --events --routines --triggers $DbName $TABLE_NAME > $DIR/$TABLE_NAME;
		docker exec -e MYSQL_PWD=$Password $Container /usr/bin/mysqldump -u $User --set-gtid-purged=OFF --add-drop-table --add-locks --create-options --disable-keys --extended-insert --single-transaction --quick --set-charset --events --routines --triggers $DbName $TABLE_NAME > $DIR/$TABLE_NAME.sql;
		update_line "The backup is in progress. Please wait$i"
		i=$i".";
		if [ ${#i} -eq 4 ]; then
			i=""
		fi
	done
# Перенос строки после завершения цикла
echo

mkdir -p backup_zabbix
mount -t nfs 192.168.1.202:/mnt/otus-project/backup_zabbix ./backup_zabbix

tar -czf ./backup_zabbix/$FILE -C $DIR .;
umount backup_zabbix
rm -r ./backup_zabbix
echo -e '\e[1;32mCongratulations, the backup is done!\e[1;m';
echo -e 'File:\e[1;31m '$FILE'\e[1;m';


show_cursor

rm -r $DIR;
unset MYSQL_PWD;
