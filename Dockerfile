FROM trafex/php-nginx:3.4.0

USER root
RUN apk add --no-cache php82-simplexml php82-bz2 php82-zip php82-iconv php82-sodium ; \
    sed -i 's/root \/var\/www\/html;/root \/var\/www\/glpi;/g' /etc/nginx/conf.d/default.conf ; \
    mkdir /var/www/glpi/

RUN wget https://github.com/glpi-project/glpi/releases/download/10.0.10/glpi-10.0.10.tgz ; \
    tar xf glpi-10.0.10.tgz ; \
    mv glpi/* /var/www/glpi/ ; \
    chown -R nobody:nobody /var/www/glpi/

USER nobody
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
