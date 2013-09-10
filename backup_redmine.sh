#! /bin/bash
#
# backup_redmine.sh
# Copyright (C) 2013 Les Polypodes <technical@lespolypodes.com>
# Inspiration: https://gist.github.com/gabrielkfr/6432185
#
# Distributed under terms of the MIT license.


# HOW TO USE :
# * configure vars (below)
# * add a root user cronjob, ex: 0 1 * * * /root/scripts/redmine-backup.sh >> /var/backups/redmine/backup.log


echo "-------------------------------------------"
echo

# -- VARS
DAY=`date +"%Y%m%d"`
HOUR=`date +"%H%M"`
# Ensure this path exists:
BACKUP_PATH=/var/backups/redmine
REDMINE_HOME=/path/to/redmine/instance
REDMINE_DB_NAME=
REDMINE_DB_USER=
REDMINE_DB_PASS=
# Ensure this `./backups` path exists:
REDMINE_DB_BACKUP=$REDMINE_HOME/backups/redmine_mysql_db.sql
REDMINE_BACKUP_NAME="redmine_"$DAY"_"$HOUR".tar.bz2"
REDMINE_BACKUP_HISTO="histo_redmine_"$DAY"_"$HOUR".tar.bz2"
REDMINE_BACKUP_LIVE_TIME=30
REDMINE_BACKUP_HISTO_LIVE_TIME=365
MODEL_BKP_DAILY=redmine_*.tar.bz2
MODEL_BKP_HISTO=histo_redmine_*.tar.bz2

# -- MySQL
echo "Snapshot backuping Redmine's MySQL db into Redmine instance..."
mysqldump -u $REDMINE_DB_USER -p$REDMINE_DB_PASS --database $REDMINE_DB_NAME > $REDMINE_DB_BACKUP
echo "($REDMINE_DB_BACKUP) done."
echo

# -- Daily full Redmine dir backup

echo "Daily backuping Redmine's directory before sending it to a remote place..."
tar -cjf $BACKUP_PATH/$REDMINE_BACKUP_NAME $REDMINE_HOME
ln -sf $BACKUP_PATH/$REDMINE_BACKUP_NAME $BACKUP_PATH/last.tar.bz2
echo "($BACKUP_PATH/$REDMINE_BACKUP_NAME) done."

# -- Monthly full Redmine dir backup
TOMORROW=`date --date=tomorrow +%d`
if [ $TOMORROW -eq "1" ]; then
    echo
    echo "End of month : monthly backuping Redmine's directory..."
    cp $BACKUP_PATH/$REDMINE_BACKUP_NAME $BACKUP_PATH/$REDMINE_BACKUP_HISTO
    echo "($BACKUP_PATH/$REDMINE_BACKUP_HISTO) done."
fi

# -- Purging old outdated backups
echo
echo "Purging outdated backups..."
find $BACKUP_PATH/$MODEL_BKP_DAILY -mtime +$REDMINE_BACKUP_LIVE_TIME -exec rm {} \;
find $BACKUP_PATH/$MODEL_BKP_HISTO -mtime +$REDMINE_BACKUP_HISTO_LIVE_TIME -exec rm {} \;
echo "done."
echo
