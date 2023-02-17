#!/bin/bash

# Backup script for GLPI

GLPI_DIR='/var/www/html/glpi'
BACKUP_DIR='/backup'
LOGFILE='/var/log/backup_glpi/backup.log'
DBUSER=root
DBPASS=$FGHB%sdfgw3
DATE=$(date +%d.%m.%Y)
LOGTIME=$(date +"%d-%m-%Y %H:%m")
DBCONFIG=$(find $GLPI_DIR -name "config_db.php")
DBNAME=$(grep "dbdefault" $DBCONFIG | cut -d "'" -f 2)
GLPISIZE=$(du -sh $GLPI_DIR)

echo -e "$LOGTIME \t## GLPI full backup started ##" >> $LOGFILE
echo -e "$LOGTIME \tCreating mysqldump into $BACKUP_DIR/sqldump.$DATE.sql ..." >> $LOGFILE
mysqldump -u $DBUSER -p$DBPASS $DBNAME > $BACKUP_DIR/sqldump.$DATE.sql
echo -e "$LOGTIME \tpacking: $GLPISIZE.. into $BACKUP_DIR/backup.$DATE.tar.bz2 file ..." >> $LOGFILE
tar -cjPf $BACKUP_DIR/backup.$DATE.tar.bz2 $GLPI_DIR $BACKUP_DIR/sqldump.$DATE.sql >> $LOGFILE
rm -rf /backup/sqldump*.sql

echo -e "$LOGTIME \tfull backup finished..." >> $LOGFILE
echo "Full backup is done! "

exit 0
