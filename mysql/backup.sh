#!/bin/bash

DATE=`date +"%Y-%m-%d_%Hh-%Mm"`
DIR=backup_$DATE

mkdir $DIR

for DB_NAME in `mysql --skip-column-names -e "SHOW DATABASES"`;
        do
                echo "Databese name = "$DB_NAME;
                mkdir $DIR/$DB_NAME;
                for TABLE_NAME in `mysql --skip-column-names -e "SHOW TABLES FROM "$DB_NAME`;
                        do
                                FILE_NAME="$(echo "$TABLE_NAME" | sed 's/\$/\_/g')";
#                               echo "Databese name = "$DB_NAME"   Table name = "$TABLE_NAME"   File name = "$FILE_NAME;
                                /usr/bin/mysqldump --add-drop-table --add-locks --create-options --disable-keys --extended-insert --single-transaction --quick --set-charset --events --routines --triggers $DB_NAME $TABLE_NAME > $DIR/$DB_NAME/$FILE_NAME;
                        done
        done;
#tar -czf $DIR.tar.gz $DIR;
#rm -r $DIR;
