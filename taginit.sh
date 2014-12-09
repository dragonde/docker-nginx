#!/bin/bash

index=/tmp/taginit.index

echo -e "\e[32mProcesando TAGINIT\e[0m"

if [ -n "$TAGINIT" ] 
then 

  segment=$(env| grep "^TAGINIT=" | perl -p -e "s/^TAGINIT=(\w+)\.(\w+)$/\1/")
  tag=$(    env| grep "^TAGINIT=" | perl -p -e "s/^TAGINIT=(\w+)\.(\w+)$/\2/")

  echo -e "\e[36mSegmento: \e[33m$segment\e[0m"
  echo -e "\e[36mTag: \e[33m$tag\e[0m"
  
  /usr/local/sbin/download-tag.sh $segment $tag /tmp

  [ ! -f $index ] && echo -e "\e]31mERROR: Indice No Encontrado\e[0m" && exit 1;

  cat $index
  
fi


[ ! -f /usr/local/sbin/init.sh ] && echo -e "\e]31mERROR: Init.sh NO encontrado\e[0m" && exit 1;

ls -lh /usr/local/sbin

echo -e "\e[36mEjecutando init.sh\e[0m"

/usr/local/sbin/init.sh
