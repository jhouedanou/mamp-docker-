#!/bin/bash
set -e

# Fonction pour attendre que MySQL soit prêt
wait_for_mysql() {
    echo "Attente de la disponibilité de MySQL..."
    while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
        sleep 1
    done
    echo "MySQL est prêt !"
}

# Fonction pour télécharger WordPress
download_wordpress() {
    if [ ! -f /var/www/html/wp-config.php ]; then
        echo "Téléchargement de WordPress..."
        cd /var/www/html
        
        # Télécharger la dernière version de WordPress
        curl -k -O https://wordpress.org/latest.tar.gz
        tar -xzf latest.tar.gz --strip-components=1
        rm latest.tar.gz
        
        # Définir les permissions
        chown -R www-data:www-data /var/www/html
        chmod -R 755 /var/www/html
        
        echo "WordPress téléchargé avec succès !"
    else
        echo "WordPress est déjà installé."
    fi
}

# Fonction pour créer wp-config.php
create_wp_config() {
    if [ ! -f /var/www/html/wp-config.php ]; then
        echo "Création du fichier wp-config.php..."
        cd /var/www/html
        
        # Copier wp-config-sample.php vers wp-config.php
        cp wp-config-sample.php wp-config.php
        
        # Remplacer les valeurs de configuration
        sed -i "s/database_name_here/$WORDPRESS_DB_NAME/g" wp-config.php
        sed -i "s/username_here/$WORDPRESS_DB_USER/g" wp-config.php
        sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/g" wp-config.php
        sed -i "s/localhost/$WORDPRESS_DB_HOST/g" wp-config.php
        
        # Générer les clés de sécurité WordPress
        SALT=$(curl -k -L https://api.wordpress.org/secret-key/1.1/salt/)
        sed -i "/#@-/,/#@+/c\\$SALT" wp-config.php
        
        # Définir les permissions
        chown www-data:www-data wp-config.php
        chmod 644 wp-config.php
        
        echo "Configuration WordPress créée avec succès !"
    fi
}

# Fonction pour créer le fichier .htaccess
create_htaccess() {
    if [ ! -f /var/www/html/.htaccess ]; then
        echo "Création du fichier .htaccess..."
        cat > /var/www/html/.htaccess << 'EOF'
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress

# Sécurité
<Files wp-config.php>
    Order allow,deny
    Deny from all
</Files>

# Compression Gzip
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
</IfModule>

# Cache des navigateurs
<IfModule mod_expires.c>
    ExpiresActive on
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/ico "access plus 1 year"
    ExpiresByType image/icon "access plus 1 year"
    ExpiresByType text/plain "access plus 1 month"
    ExpiresByType application/pdf "access plus 1 month"
    ExpiresByType application/x-shockwave-flash "access plus 1 month"
</IfModule>
EOF
        chown www-data:www-data /var/www/html/.htaccess
        chmod 644 /var/www/html/.htaccess
        echo "Fichier .htaccess créé avec succès !"
    fi
}

# Exécution des fonctions
echo "Démarrage de l'initialisation WordPress..."

# Attendre que MySQL soit prêt
wait_for_mysql

# Télécharger WordPress
download_wordpress

# Créer la configuration
create_wp_config

# Créer .htaccess
create_htaccess

echo "Initialisation WordPress terminée !"
echo "Vous pouvez maintenant accéder à WordPress sur http://localhost"
echo "Pour phpMyAdmin, accédez à http://localhost:8080"

# Démarrer Apache en premier plan
exec "$@" 