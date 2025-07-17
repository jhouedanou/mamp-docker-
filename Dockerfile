FROM ubuntu:22.04

# Éviter les interactions pendant l'installation
ENV DEBIAN_FRONTEND=noninteractive

# Mise à jour du système et installation des dépendances
RUN apt-get update && apt-get install -y \
    apache2 \
    software-properties-common \
    curl \
    wget \
    unzip \
    git \
    nano \
    mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Ajout du repository PHP officiel
RUN add-apt-repository ppa:ondrej/php -y

# Installation de PHP 8.3 et des extensions nécessaires pour WordPress
RUN apt-get update && apt-get install -y \
    php8.3 \
    php8.3-cli \
    php8.3-common \
    php8.3-mysql \
    php8.3-zip \
    php8.3-gd \
    php8.3-mbstring \
    php8.3-curl \
    php8.3-xml \
    php8.3-bcmath \
    php8.3-opcache \
    php8.3-intl \
    php8.3-soap \
    php8.3-xmlrpc \
    php8.3-imagick \
    php8.3-fpm \
    libapache2-mod-php8.3 \
    && rm -rf /var/lib/apt/lists/*

# Activation des modules Apache nécessaires
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enmod headers
RUN a2enmod expires

# Configuration PHP pour WordPress
RUN echo "upload_max_filesize = 64M" >> /etc/php/8.3/apache2/php.ini
RUN echo "post_max_size = 64M" >> /etc/php/8.3/apache2/php.ini
RUN echo "memory_limit = 256M" >> /etc/php/8.3/apache2/php.ini
RUN echo "max_execution_time = 300" >> /etc/php/8.3/apache2/php.ini
RUN echo "max_input_vars = 3000" >> /etc/php/8.3/apache2/php.ini

# Configuration du DocumentRoot
RUN sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html/g' /etc/apache2/sites-available/000-default.conf

# Création du répertoire pour WordPress
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Script d'initialisation pour télécharger WordPress
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Exposition du port 80
EXPOSE 80 443

# Point d'entrée
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2ctl", "-D", "FOREGROUND"] 