#!/bin/bash
USER_NAME=ec
USER_ID=1001
GROUP_ID=100
NAME=BACKUP-EC

USER_PERSO="/share/persos/ec"          # Le répertoire personnel non visible samba pour cet utilisateur
USER_HOME="/share/homes/ec"            # Le répertoire home de l'utilisateur sur le NAS


CONFIG="$USER_PERSO/config"            # Répertoire qui contient des données de config ( clés SSH...)
DATA_HOME="$USER_HOME"                 # Répertoire qui contient les données à backuper
DATA_PERSO="$USER_PERSO/dataperso"     # Répertoire qui contient les données à backuper
PREF_DIRS="$USER_PERSO/pref-dirs"      # Répertoire qui contient les -pref-dir pour duplicacy
REPORTS="/share/Web/backup-ec/reports" # Répertoire dans lequel on écrira les rapports d'exécution
RESTORE="$USER_PERSO/restore"          # Répertoire dans lequel on Lancera les restore

SSH_PORT=50086

docker kill $NAME
docker rm  $NAME
docker pull ech1965/backup-nas:latest
# à mettre RO plus tard
# /jobs
# /datahomme et /dataperso (une fois que les repos duplicacy sont créés)
docker create \
  --name=$NAME \
  -v /etc/localtime:/etc/localtime \
  -v $CONFIG:/config \
  -v $DATA_HOME:/datahome  \
  -v $DATA_PERSO:/dataperso  \
  -v $PREF_DIRS:/pref-dirs  \
  -v $REPORTS:/reports \
  -v $RESTORE:/restore \
  -p $SSH_PORT:22 \
  -e PGID=$GROUP_ID -e PUID=$USER_ID -e PUSER=$USER_NAME  \
  ech1965/backup-nas:latest

docker start $NAME




