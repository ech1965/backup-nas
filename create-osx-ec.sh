#!/bin/bash
NAME=BACKUP-EC

docker kill $NAME
docker rm  $NAME
docker create \
  --name=$NAME \
  -v $PWD/test/backup:/backup \
  -v $PWD/test/config:/config \
  -v $PWD/test/data:/data \
  -v $PWD/test/restore:/restore \
  -v $PWD/test/rdiffweb:/etc/rdiffweb \
  -p 20022:22 \
  -p 8080:8080 \
  -e PGID=501 -e PUID=501 -e PUSER=ec  \
  ech1965/backup-nas:0.1.0
docker start $NAME
