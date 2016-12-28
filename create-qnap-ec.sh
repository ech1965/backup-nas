#!/bin/bash
USER_NAME=ec
USER_ID=1001
GROUP_ID=100
NAME=BACKUP-EC

# Top level folder in backup area
BACKUP_HOME=/share/Backups/$USER_NAME
# Folder for configuration files
CONFIG_HOME=$BACKUP_HOME/Configuration/config
# Folder for Backup jobs
JOBS_HOME=$BACKUP_HOME/Configuration/jobs
# Folder for rdiffweb persistent data ( config file & sqlite database)
RDIFFWEB_HOME=$BACKUP_HOME/Configuration/rdiffweb
# Root folder for rdiff-backup repositories
REPOSITORIES_ROOT=$BACKUP_HOME/BACKUPS
RESTORE_POINT=$BACKUP_HOME/RESTORE
HOME_FOLER=/share/homes/$USER_NAME
SSH_PORT=50086
WEB_PORT=50087

docker kill $NAME
docker rm  $NAME
docker create \
  --name=$NAME \
  -v $REPOSITORIES_HOME:/repositories \
  -v $CONFIG_HOME:/config \
  -v $HOME_FOLDER:/sourcedata:ro  \
  -v $RESTORE_POINT:/restore \
  -v $RDIFFWEB_HOME:/etc/rdiffweb \
  -p $SSH_PORT:22 \
  -p $WEB_PORT:8080 \
  -e PGID=$USER_ID -e PUID=$GROUP_ID -e PUSER=$USER_ID  \
  ech1965/backup-nas:0.1.0
docker start $NAME