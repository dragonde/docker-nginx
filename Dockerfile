FROM ubuntu:14.10
MAINTAINER dragonde <dragonde@dragonde.es>

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

# Basic Requirements NGINX 
RUN apt-get -y install nginx 

# Basic Tools
RUN apt-get -y install supervisor 

# Root Directory www
VOLUME  /www

# private expose www
EXPOSE 80

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisor/supervisord.conf"]
