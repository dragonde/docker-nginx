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

ADD nginx-site.conf /etc/nginx/sites-enabled/default 

# Basic Tools
RUN apt-get -y install supervisor 

ADD supervisord.conf /etc/supervisor/supervisord.conf

# Root Directory www
VOLUME  /usr/share/nginx/html

# private expose www
EXPOSE 80

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisor/supervisord.conf"]
