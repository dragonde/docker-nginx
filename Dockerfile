FROM ubuntu:14.10
MAINTAINER dragonde <dragonde@dragonde.es>

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
#RUN apt-get -y upgrade

# Basic Requirements NGINX PHP
RUN apt-get -y install nginx php5-fpm php5-mysql php-apc

# Wordpress Requirements
RUN apt-get -y install php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl

# Basic Tools
RUN apt-get -y install supervisor curl pwgen mysql-client ansible openssh-client

# Root Directory www
VOLUME  /www
VOLUME  /proper


# TAGINIT 
ADD https://raw.githubusercontent.com/dragonde/masterget/master/masterget /usr/local/sbin/masterget

RUN chmod 700 /usr/local/sbin/masterget

# private expose www
EXPOSE 80

CMD ["masterget","-x","init.sh"]
