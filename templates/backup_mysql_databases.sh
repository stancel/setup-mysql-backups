#!/bin/bash
###################################################################
#Script Name	backup_mysql_databases.sh                                                                                              
#Description	Runs the mysqldump command to backup databases, move them to a folder and keep only a certain number                                                                               
#Args           	None                                                                                           
#Author       	Brad Stancel                                             
#Email         	brad.stancel@gmail.com                                           
###################################################################

### MySQL Server Login Info ###
MUSER="root"
MPASS="{{ setup_mysql_backups_mysql_root_password }}"
MHOST="localhost"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
DESTINATION="/backups/mysql"
GZIP="$(which gzip)"
declare -i NUM_BACKUPS_TO_KEEP={{ setup_mysql_backups_num_db_backups_to_keep }}
NOW=$(date +"%m-%d-%Y")
### Space separated list of all databases to backup
DBS_TO_BACKUP={% for db in setup_mysql_backups_dbs_to_backup %}{{ db }}{% if not loop.last %} {% endif %}{% endfor %}

### FTP SERVER Login info ###
#FTPU="FTP-SERVER-USER-NAME"
#FTPP="FTP-SERVER-PASSWORD"
#FTPS="FTP-SERVER-IP-ADDRESS"
#NOW=$(date +"%m-%d-%Y")
 
### See comments below ###
### [ ! -d $BAK ] && mkdir -p $BAK || /bin/rm -f $BAK/* ###
[ ! -d ${DESTINATION} ] && mkdir -p ${DESTINATION}
 
#$DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
#for db in $DBS
for db in ${DBS_TO_BACKUP}
do
 FILE=${DESTINATION}/mysql-db-${db}.${NOW}-$(date +"%T").gz
 $MYSQLDUMP --single-transaction -u $MUSER -h $MHOST -p$MPASS $db | $GZIP -9 > $FILE
done

cd ${DESTINATION}
#num_files=`ls | wc -l`
#rm `ls -tp | grep -v "/$" | awk '{ if (NR > "$NUM_BACKUPS_TO_KEEP") print; }'`

declare -i NUM_TO_KEEP=$(($NUM_BACKUPS_TO_KEEP + 1))

ls -t1 ${DESTINATION} | tail -n +$NUM_TO_KEEP | xargs rm -rf
#lftp -u $FTPU,$FTPP -e "mkdir /mysql/$NOW;cd /mysql/$NOW; mput /backup/mysql/*; quit" $FTPS

[ ! -d ${DESTINATION}/current ] && mkdir -p ${DESTINATION}/current

rm -f ${DESTINATION}/current/*

cp -p `ls -dtr1 ${DESTINATION}/*.gz | tail -1` ${DESTINATION}/current/

### AFTER THIS IS SETUP A CRON JOB WITH THE BELOW COMMANDS
# crontab -e
### THEN PASTE THIS IN:
## BRAD EDIT - Backing Up the MySQL DB Every Night
#@midnight /root/backup_mysql_databases.sh >/dev/null 2>&1
