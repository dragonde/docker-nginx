#!/bin/bash

index=/tmp/tag.index

echo -e "\e[32mProcesando TAGINIT\e[0m"

if [ -n "$TAGINIT" ] 
then 

  segment=$(env| grep "^TAGINIT=" | perl -p -e "s/^TAGINIT=(\w+)\.(\w+)$/\1/")
  tag=$(    env| grep "^TAGINIT=" | perl -p -e "s/^TAGINIT=(\w+)\.(\w+)$/\2/")

  echo -e "\e[36mSegmento: \e[33m$segment\e[0m"
  echo -e "\e[36mTag: \e[33m$tag\e[0m"
  
  /usr/local/sbin/download-tag.sh $segment $tag /tmp

  [ ! -f $index ] && echo -e "\e]31mERROR: Indice No Encontrado\e[0m" && exit 1;
 
  function download_line {
    echo -e "\e[36mDWL: $1 $2 $3 $4 $5\e[0m";
    #$1 segmento $3 tag $5 directorio $6chmod
    /usr/local/sbin/download-tag.sh $1 $3 $5
    [ -n "$6" ] && echo -e "\e[36mCHMOD $6 $5\e[0m" && chmod -R $6 $5
    exit
  }

  export -f download_line 

  cat $index | tr '\n' '\0' | xargs -0 bash -c 'download_line "$segment $@"'

  rm -f $index

fi


[ ! -f /usr/local/sbin/init.sh ] && echo -e "\e[31mERROR: Init.sh NO encontrado\e[0m" && exit 1;

ls -lh /usr/local/sbin

echo -e "\e[36mEjecutando init.sh\e[0m"

/usr/local/sbin/init.sh
