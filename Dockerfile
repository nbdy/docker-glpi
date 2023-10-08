FROM trafex/php-nginx:3.4.0

ENV GLPI_VAR_DIR "/var/glpi/files"
ENV GLPI_CONFIG_DIR "/var/glpi/config"

USER root
RUN apk add --no-cache php82-simplexml php82-bz2 php82-zip php82-iconv php82-sodium php82-exif php82-ldap ; \
    mkdir /var/www/glpi/ /var/glpi

COPY default.conf /etc/nginx/conf.d/default.conf
COPY php.ini ${PHP_INI_DIR}/conf.d/custom.ini

RUN rm /var/www/html/* ; \
    wget https://github.com/glpi-project/glpi/releases/download/10.0.10/glpi-10.0.10.tgz ; \
    tar xf glpi-10.0.10.tgz ; \
    mv glpi/files glpi/config /var/glpi ; \
    mv glpi/* /var/www/glpi/ ; \
    chown -R nobody:nobody /var/www/glpi/ ; \
    chown -R nobody:nobody /var/glpi

RUN rm glpi-10.0.10.tgz

USER nobody
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
