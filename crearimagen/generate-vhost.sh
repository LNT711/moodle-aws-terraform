#!/bin/bash
set -e

# Cargar variables
source ./vhost-config.env

# Definir paths
VHOST_FINAL="./vhost-final/${SUBDOMAIN}.${DOMAIN}.conf"
DOCROOT="./htdocs/${SUBDOMAIN}.${DOMAIN}"

# Crear docroot local
mkdir -p "$DOCROOT"
echo "<?php phpinfo(); ?>" > "$DOCROOT/info.php"

# Crear archivo final de vhost
mkdir -p ./vhost-final
cat > "$VHOST_FINAL" <<EOF
<VirtualHost *:80>
    ServerName ${SUBDOMAIN}.${DOMAIN}
    ServerAlias ${SUBDOMAIN}.${DOMAIN}
    DocumentRoot /bitnami/moodle
    ErrorLog /opt/bitnami/apache/logs/${SUBDOMAIN}.${DOMAIN}-error.log
    CustomLog /opt/bitnami/apache/logs/${SUBDOMAIN}.${DOMAIN}-access.log combined

    <Directory /bitnami/moodle/>
        Options FollowSymLinks
        AllowOverride None
        DirectoryIndex index.php index.html
        Require all granted
    </Directory>
</VirtualHost>
EOF
