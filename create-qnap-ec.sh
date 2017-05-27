#!/bin/bash
USER_NAME=ec
USER_ID=1001
GROUP_ID=100
NAME=BACKUP-EC

# Top level folder in backup area
BACKUP_HOME=/share/Backups/$USER_NAME
# Folder for configuration files
CONFIG_HOME=$BACKUP_HOME/Configuration/config
# Folder for backup jobs
JOBS_HOME=$BACKUP_HOME/Configuration/jobs
# Reports generated from cron
REPORTS_HOME=/share/Web/backup-ec/reports/
# Folder for rdiffweb persistent data ( config file & sqlite database)
RDIFFWEB_HOME=$BACKUP_HOME/Configuration/rdiffweb
# Root folder for rdiff-backup repositories
REPOSITORIES_ROOT=$BACKUP_HOME/BACKUPS
RESTORE_POINT=$BACKUP_HOME/RESTORE
HOME_FOLDER=/share/homes/$USER_NAME
SSH_PORT=50086
WEB_PORT=50087

docker kill $NAME
docker rm  $NAME
docker pull ech1965/backup-nas:latest

docker create \
  --name=$NAME \
  -v /etc/localtime:/etc/localtime \
  -v $REPOSITORIES_ROOT:/repositories \
  -v $CONFIG_HOME:/config \
  -v $REPORTS_HOME:/reports \
  -v $HOME_FOLDER:/sourcedata  \
  -v $JOBS_HOME:/jobs:ro  \
  -v $RESTORE_POINT:/restore \
  -v $RDIFFWEB_HOME:/etc/rdiffweb \
  -p $SSH_PORT:22 \
  -p $WEB_PORT:8080 \
  -e PGID=$GROUP_ID -e PUID=$USER_ID -e PUSER=$USER_NAME  \
  ech1965/backup-nas:latest

docker start $NAME




