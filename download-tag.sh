#!/bin/bash
# ARGs: segmento tag directorio

storage='https://storage.googleapis.com'

[ -z $3 ] && echo -e "\e[91mPARAMETROS MAL\n$0 $1 $2 $3" && exit 1;

file=/tmp/$2

echo -e "\e[36mDescargando \e[33m$1 \e[94m$2\e[0m"

curl -sSL $storage/$1/$2 -o $file

if [ -s $file ]
then 
  md5=$(md5sum $file | head -c 20)
  [ "$md5" != "$2" ]  && echo -e "\e[91mERROR MD5 en $1 $2\e[0m" && exit 1;
else 
   echo -e "\e[91mERROR DESCARGA en $1 $2\e[0m" && exit 1;
fi

echo -e "\e[36mDescomprimiendo en \e[33m$3\e[0m"

tar zx -C $3 -f $file

rm -f $file

