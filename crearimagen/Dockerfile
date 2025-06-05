FROM bitnami/moodle:4.2

# Copiar configuraciones personalizadas
COPY php-custom.ini /opt/bitnami/php/etc/conf.d/php-custom.ini
COPY apache-custom.conf /opt/bitnami/apache/conf/bitnami/extra/httpd-mpm.conf
# Copiar vhost y docroot generados
COPY ./vhost-final/*.conf /opt/bitnami/apache/conf/vhosts/
COPY ./htdocs /opt/bitnami/apache/htdocs/
