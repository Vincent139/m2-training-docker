FROM php:7.2-apache-stretch

MAINTAINER Clever-Age DevOps Team <system@clever-age.com>

RUN printf "deb http://deb.debian.org/debian stretch-backports main contrib non-free" \
    > /etc/apt/sources.list.d/stretch-backports.list
# Basic tools
#
RUN apt-get update && apt-get install -y \
    vim \
    curl \
    wget \
    git \
    unzip \
    mysql-client \
    pv \
    netcat \
    sudo \
    bison \
    byacc

# PHP Dependencies :
# http://devdocs.magento.com/guides/v2.2/install-gde/system-requirements-tech.html
#
# PHP modules :
# bc-math (Magento Commerce only)
# ctype
# curl
# dom
# gd : libfreetype6-dev / libjpeg62-turbo-dev / libpng-dev
# intl : libicu-dev
# mbstring
# hash
# openssl
# PDO/MySQL
# SimpleXML
# soap
# spl
# libxml
# xsl : libxslt-dev
# zip
# json
# iconv
#
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
      	libxslt-dev \
      	libicu-dev \
      	libldap2-dev \
    && apt-get install -y -t stretch-backports libsodium-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-configure hash --with-mhash \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        zip \
        soap \
        xmlrpc \
        opcache \
        gd \
      	bcmath \
      	intl \
      	xsl \
      	ldap \
      	sodium

# PHP PECL Extension
#
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Apache modules
#
RUN a2enmod alias \
   rewrite \
   expires \
   headers \
   rewrite \
   deflate \
   status \
   ssl

# Install Composer
#
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Mails
#
RUN apt-get install -y ssmtp && \
    echo "sendmail_path = /usr/sbin/ssmtp -t" > /usr/local/etc/php/conf.d/sendmail.ini && \
    echo "mailhub=mail.local:1025\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf

# User Magento to deploy code
# see : https://vsupalov.com/docker-env-vars/
#
ARG magento_uid=1000
ARG magento_gid=1000
ENV SRC_USER=magento USER_ID="${magento_uid}" USER_GID="${magento_gid}"

# Now creating user
RUN groupadd --gid "${USER_GID}" "${SRC_USER}" && \
    useradd \
      --uid ${USER_ID} \
      --gid ${USER_GID} \
      --create-home \
      --shell /bin/bash \
      ${SRC_USER}

# Add www-data to group magento (www-data write allow by g+w)
RUN usermod -a -G ${SRC_USER} www-data

# Add magento user to group www-data (www-data file created with group right can be deleted)
RUN usermod -a -G www-data ${SRC_USER}

# COPY ./files/auth.json /home/magento/.composer/auth.json
# RUN chown -R magento /home/magento/.composer

# Add certificates
#
RUN mkdir /etc/apache2/ssl
COPY ./files/etc/apache2/ssl/formation.local.crt /etc/apache2/ssl/formation.local.crt
COPY ./files/etc/apache2/ssl/formation.local.key /etc/apache2/ssl/formation.local.key
RUN mkdir -p /usr/share/ca-certificates && \
   cp /etc/apache2/ssl/formation.local.crt  /usr/local/share/ca-certificates/ && \
   update-ca-certificates

# PHP configuration
#
COPY ./files/etc/php/php.ini /usr/local/etc/php/

# Apache ports configuration
COPY ./files/etc/apache2/ports.conf /etc/apache2/ports.conf

# Vhost
COPY ./files/etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf

COPY ./files/etc/apache2/sites-available/001-formation.conf /etc/apache2/sites-available/001-formation.conf
RUN a2ensite 001-formation

# Add crontab
#
COPY ./files/etc/cron.d/magento2 /etc/cron.d/magento2

# Copy Installation files
#
COPY ./files/usr/local/bin/* /usr/local/bin/
RUN chmod -R +x /usr/local/bin/

# Cleanup
#
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# EntryPoint
#
COPY ./files/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]

# CMD - launch apache2
#
CMD ["apache2-foreground"]
