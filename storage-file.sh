#!/bin/bash

# shell functions than provides storage
# usage: storage command segment tag file
# commands: get, put, format

if [ $# -lt 4 ]
then
        echo "Usage : $0 Command Segment Tag File"
        exit
fi

case "$1" in

get)  echo -e "\e[35mget $2 $3 => $4\e[0m"
    cp -av /$2/$3 $4 
    ;;
esac

