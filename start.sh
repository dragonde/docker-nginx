#!/bin/bash

  chown -R www-data:www-data /www

### Inicialización del Sistema
  
  /usr/local/sbin/download-taginit.sh
  
### Arrancando Supervidor 

  echo -e "\e[32mArrancando Supervisord ...\e[0m"

  /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

