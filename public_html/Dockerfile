FROM debian:12-slim as ocr
LABEL maintainer="radu@ardux.ro"

ENV DEBIAN_FRONTEND=noninteractive

# Add Sury PHP repository for PHP 7.3.33
RUN apt-get update -y && \
    apt-get install -y wget gnupg2 lsb-release ca-certificates && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y apache2

# Install PHP 7.3.33 specifically
RUN apt-get update && apt-get install -y php7.3=7.3.33*

COPY config/dev.laptop.io.conf /etc/apache2/sites-available/dev.laptop.io.conf

# COPY ./config/laptopdr_m230.sql /root/laptopdr_m230.sql

COPY ./config/provision.sh /provision.sh
# we will run this script at startup of the container, after all the services are started
# see docker-compose: command
RUN chmod +x /provision.sh

RUN rm -f /var/www/html/index.html
RUN mkdir /var/www/html/laptop_ro

RUN a2ensite dev.laptop.io.conf
RUN service apache2 restart

# Install MariaDB (using default Debian 12 version - should be 10.11.x)
RUN apt-get update \
    && apt-get install -y apt-utils \
    && { \
        echo mariadb-server mysql-server/root_password password 'radu1980'; \
        echo mariadb-server mysql-server/root_password_again password 'radu1980'; \
    } | debconf-set-selections \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server mariadb-client

# Install core PHP extensions
RUN apt-get install -y \
    php7.3-dev=7.3.33* \
    php7.3-mysql=7.3.33* \
    php7.3-xml=7.3.33*

# Install mcrypt 1.0.7
RUN apt-get update && apt-get install -y libmcrypt-dev
RUN apt-get -y install gcc make autoconf libc-dev pkg-config
RUN apt-get -y install libmcrypt-dev
RUN pecl install mcrypt-1.0.7
RUN echo "extension=mcrypt.so" > /etc/php/7.3/apache2/conf.d/20-mcrypt.ini
RUN echo "extension=mcrypt.so" > /etc/php/7.3/cli/conf.d/20-mcrypt.ini

RUN apt-get update && apt-get install -y libzip-dev
RUN apt-get update && apt-get install -y zip

# Install main PHP extensions in groups
RUN apt-get install -y \
    php7.3-bcmath=7.3.33* \
    php7.3-opcache=7.3.33* \
    php7.3-soap=7.3.33* \
    php7.3-intl=7.3.33* \
    php7.3-gd=7.3.33* \
    php7.3-curl=7.3.33* \
    php7.3-json=7.3.33* \
    php7.3-common=7.3.33* \
    php7.3-mbstring=7.3.33*

# Install mysqli (virtual package)
RUN apt-get install -y php7.3-mysqli

# Install IMAP extension
RUN apt-get update && apt install -y libc-client-dev libkrb5-dev
RUN apt-get install -y php7.3-imap=7.3.33*
RUN phpenmod imap

# Install additional PHP modules (grouped for efficiency)
# Core extensions (usually virtual packages or built-in)
RUN apt-get install -y \
    php7.3-calendar \
    php7.3-ctype \
    php7.3-dom \
    php7.3-exif \
    php7.3-fileinfo \
    php7.3-ftp \
    php7.3-gettext \
    php7.3-iconv \
    php7.3-pdo \
    php7.3-pdo-mysql \
    php7.3-phar \
    php7.3-posix \
    php7.3-simplexml \
    php7.3-tokenizer \
    php7.3-xmlreader \
    php7.3-xmlwriter

# Extensions that support version pinning
RUN apt-get install -y \
    php7.3-readline=7.3.33* \
    php7.3-xsl=7.3.33* \
    php7.3-zip=7.3.33*

RUN service apache2 start

RUN apt-get install -y nano

RUN apt-get install -y wget
RUN apt-get install -y cron

## nu rulam cronul de mail, sa nu stearga din mailuri
## RUN echo "*/5 * * * * root php /var/www/html/briel/index.php cronjob cron_read_email" >> /etc/crontab

COPY ./config/php.ini /etc/php/7.3/apache2/conf.d/30-dockerphp.ini

# Enable required Apache modules
RUN a2enmod rewrite \
    && a2enmod ssl \
    && a2enmod headers \
    && a2enmod expires \
    && a2enmod deflate \
    && a2enmod filter \
    && a2enmod setenvif \
    && a2enmod env \
    && a2enmod dir \
    && a2enmod mime \
    && a2enmod negotiation \
    && a2enmod autoindex \
    && a2enmod alias \
    && a2enmod auth_basic \
    && a2enmod authn_core \
    && a2enmod authn_file \
    && a2enmod authz_core \
    && a2enmod authz_host \
    && a2enmod authz_user \
    && a2enmod access_compat \
    && a2enmod reqtimeout \
    && a2enmod status \
    && a2enmod php7.3

EXPOSE 80
EXPOSE 443