#!/bin/bash

Container=mysql-sourse;
DbName=zabbix;
User=root;
Password=example;
#export MYSQL_PWD=example;
#export MYSQL_PWD=$Password;
DATE=`date +"%Y-%m-%d_%Hh-%Mm"`;
DIR=backup_$DbName"_"$DATE;

mkdir $DIR;

echo "Source DBMS = "$Container;
echo "Databese name = "$DbName;
#for TABLE_NAME in `docker exec $Container mysql -u$User -p$Password --skip-column-names -e "SHOW TABLES FROM "$DbName`;
for TABLE_NAME in `docker exec -e MYSQL_PWD=$Password $Container mysql -u$User --skip-column-names -e "SHOW TABLES FROM "$DbName`;
	do
#		docker exec $Container /usr/bin/mysqldump -u $User --password=$Password --add-drop-table --add-locks --create-options --disable-keys --extended-insert --single-transaction --quick --set-charset --events --routines --triggers $DbName $TABLE_NAME > $DIR/$TABLE_NAME;
		docker exec -e MYSQL_PWD=$Password $Container /usr/bin/mysqldump -u $User --set-gtid-purged=OFF --add-drop-table --add-locks --create-options --disable-keys --extended-insert --single-transaction --quick --set-charset --events --routines --triggers $DbName $TABLE_NAME > $DIR/$TABLE_NAME;
	done
tar -czf $DIR.tar.gz -C $DIR .;
echo "Congratulations, the backup is done! File:"+$DIR+".tar.gz";
rm -r $DIR;
unset MYSQL_PWD;



cat backup.sql | docker exec -i $Container /usr/bin/mysql -u $User --password=$Password $DbName

cat backup.sql | docker exec -i CONTAINER /usr/bin/mysql -u root --password=root DATABASE
