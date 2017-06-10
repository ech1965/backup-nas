#!/bin/bash
USER_NAME=ec
USER_ID=1001
GROUP_ID=100
NAME=BACKUP-EC

# Top level folder in backup area
BACKUP_HOME=/share/Backups/$USER_NAME

# Folder for backup jobs (scripts & cron)
JOBS_HOME=$BACKUP_HOME/Configuration/jobs

# Folder for configuration files
CONFIG_HOME=$BACKUP_HOME/Configuration/config

# User's home in NAS 
HOME_FOLDER=/share/homes/$USER_NAME
PERSO_FOLDER=$BACKUP_HOME/perso

# Folder for pref-dir's
PREF_DIR_FOLDER=$BACKUP_HOME/pref-dirs

# Reports generated from cron
REPORTS_HOME=/share/Web/backup-ec/reports/

# Folder for restoration
RESTORE_POINT=$BACKUP_HOME/RESTORE



SSH_PORT=50086
#WEB_PORT=50087

docker kill $NAME
docker rm  $NAME
docker pull ech1965/backup-nas:latest
# à mettre RO plus tard
# /jobs
# /datahomme et /dataperso (une fois que les repos duplicacy sont créés)
docker create \
  --name=$NAME \
  -v /etc/localtime:/etc/localtime \
  -v $JOBS_HOME:/jobs  \
  -v $CONFIG_HOME:/config \
  -v $HOME_FOLDER:/datahome  \
  -v $PERSO_FOLDER:/dataperso  \
  -v $PREF_DIR_FOLDER:/pref-dirs  \
  -v $REPORTS_HOME:/reports \
  -v $RESTORE_POINT:/restore \
  -p $SSH_PORT:22 \
  -e PGID=$GROUP_ID -e PUID=$USER_ID -e PUSER=$USER_NAME  \
  ech1965/backup-nas:latest

docker start $NAME




