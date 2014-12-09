#!/bin/bash

  chown -R www-data:www-data /www

### Inicialización del Sistema
  
  /usr/local/sbin/taginit.pl

### Arrancando Supervidor 

  echo -e "\n\e[32mArrancando Supervisord ...\e[0m\n"

  /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

