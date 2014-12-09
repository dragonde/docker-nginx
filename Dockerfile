FROM ubuntu:14.10
MAINTAINER dragonde <dragonde@dragonde.es>

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

# Basic Requirements NGINX PHP
RUN apt-get -y install nginx php5-fpm php5-mysql php-apc

# Wordpress Requirements
RUN apt-get -y install php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl

# Basic Tools
RUN apt-get -y install supervisor curl pwgen mysql-client ansible

# Supervisor Config
ADD ./supervisord.conf /etc/supervisor/supervisord.conf

# nginx site conf
ADD ./nginx-site.conf /etc/nginx/sites-available/default

# Root Directory www
VOLUME  /www

# TAGINIT 
ADD ./taginit.pl /usr/local/sbin/taginit.pl
ADD ./download-tag.sh /usr/local/sbin/download-tag.sh

# Fichero de Inicio
ADD ./start.sh /usr/local/sbin/start.sh

# Permisos sobre sbin
RUN chmod 500  /usr/local/sbin/*

# private expose www
EXPOSE 80

CMD ["/bin/bash", "/usr/local/sbin/start.sh"]
