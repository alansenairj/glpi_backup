# glpi_backup

# Administração de backup GPLI

Script que cria e gera backup full e lite do glpi

# copiar arquivos
copiar para /usr/local/bin
chmod +x backup_glpi2.sh

# checando as tabelas
mysql -uroot -p glpidb
SHOW TABLES;


# Testando backup do banco
mysqldump -u root glpidb > backup.sql

# Instalando dependências debian
apt install zip multitail

# Agendando a tarefa de backup no cron
crontab -e
```

# m h  dom mon dow   command
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed

# backup glpi
00 13,23 * * * bash /usr/local/bin/backup_glpi2.sh full  2>&1 | tee  /var/log/backup_glpi/`date +\%Y-\%m-\%d_\%H-\%M`-full.log

#glpi cron
* *	* * *	root	php /var/www/html/glpi/front/cron.php

# limpeza de logs de backup do glpi
00 05 * * * 	find /var/log/backup_glpi/ -name '*.log' -daystart -mtime +3 -exec rm '{}' \;

```



# Exemplo do arquivo de log gerado.
/var/log/backupglpi/lite-05-10-2018_10-30.log

# Conferindo logs de backup
multitail  -n 300 /var/log/backupglpi/2018-10-05_23-00-full.log


# Restaurando o backup
cd /var/backups/glpi/
stat -c %n *

# Lendo os arquivos zipados antes de o descompactarmos.
unzip -l  2018-10-06_07-30-bkpglpi-lite.zip | grep .sql


# Descompactando apenas o backup do banco de dados
cd /var/backups/glpi
 unzip 2018-10-05_23-00-bkpglpi-full.zip  files/_dumps/2018-10-05_23-00.sql -d  /var/www/html/glpi/

# Uma vez extraído o aquivos podemos restaurar a base usando a seguinte sintaxe. mysql -u root -p base < base.sql
 mysql  -u root  -p glpi < /var/www/html/glpi/files/_dumps/2018-10-06_07-30.sql


# Restauração completa do diretório
 unzip  /var/backups/glpi/2018-10-05_23-00-bkpglpi-full.zip -d /var/www/html/glpi/ 

# Definir o grupo e usuário do diretório glpi
chown  www-data.www-data -Rf /var/www/html/glpi/

# restaurar o base de dados
mysql  -u root  -p glpi < /var/www/html/glpi/files/_dumps/2018-10-05_23-00.sql




# se precisar restaurar do zero tem que criar uma nova base
mysql -u root -e "create database glpi";


# erros

root@glpi:/backup# mysqldump -u root glpidb > backup.sql
mysqldump: Got error: 1932: "Table 'glpidb.glpi_notimportedemails' doesn't exist in engine" when using LOCK TABLES

#recriar tabela

```

DROP TABLE IF EXISTS `glpi_notimportedemails`;
CREATE TABLE `glpi_notimportedemails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` varchar(255) NOT NULL,
  `to` varchar(255) NOT NULL,
  `mailcollectors_id` int(11) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL,
  `subject` text,
  `messageid` varchar(255) NOT NULL,
  `reason` int(11) NOT NULL DEFAULT '0',
  `users_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  KEY `mailcollectors_id` (`mailcollectors_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


```
