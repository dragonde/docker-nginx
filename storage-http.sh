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

# ...@http:https://178.../web

get)  echo -e "\e[35mget $2 $3 => $4\e[0m"
    curl -sSL "$2/$3" -o $4
    ;;
esac

