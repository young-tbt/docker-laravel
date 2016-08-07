FROM starchat/starchat-webapp-base

EXPOSE 22 80

RUN apt-get update && apt-get install -y openssh-server vim sudo zip unzip libapache2-mod-php7.0 php7.0-mbstring php7.0-xml php7.0-mysql
#RUN apt-get install libapache2-mod-php7.0 php7.0-mbstring php7.0-xml

# enable mod_rewrite
RUN sudo a2enmod rewrite
RUN sudo a2enmod proxy
RUN sudo a2enmod proxy_http
RUN sudo a2enmod php7.0

RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf
RUN sudo a2enconf servername

RUN sudo composer global require "laravel/installer"
RUN sudo composer global require "phpunit/phpunit"

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# COPY ./public-html/ /usr/local/apache2/htdocs/
# COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

ADD start.sh /usr/local/bin/start.sh
RUN sudo chmod +x /usr/local/bin/start.sh

ENTRYPOINT [ "/bin/bash", "-c", "/usr/local/bin/start.sh"]
