#!/bin/bash

# shell functions than provides storage
# usage: storage command segment tag file
# commands: get, put, format

# ...@scp:root:server.domain.com:port:/root_to/key

if [ $# -lt 4 ]
then
        echo "Usage : $0 Command Segment Tag File"
        exit
fi

user=$(echo $2 | perl -pe "s|^(.+):(.+):(.+):(.+)$|\1|")
server=$(echo $2 | perl -pe "s|^(.+):(.+):(.+):(.+)$|\2|")
port=$(echo $2 | perl -pe "s|^(.+):(.+):(.+):(.+)$|\3|")
key=$(echo $2 | perl -pe "s|^(.+):(.+):(.+):(.+)$|\4|")

[ -z "$key" ] && echo "Formato Segmento Incorrecto ... $2" && exit 1

echo SSH => User: $user, Server: $server, Port: $port, Key: $key

[ ! -f $key ] && echo "Clave no ENCONTRADA" && exit 1


case "$1" in

get)  echo -e "\e[35mget $2 $3 => $4\e[0m"
    scp -i $key -P $port -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" $user@$server:$3 $4 
    ;;
esac

