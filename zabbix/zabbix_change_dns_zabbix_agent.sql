mysql -uroot -pexample
use zabbix;
UPDATE interface SET dns = 'zabbix-agent' WHERE hostid = 10084;
UPDATE interface SET useip = '0' WHERE hostid = 10084;
exit;
