FROM nginx:1.13-alpine

COPY mo /usr/local/bin/mo

RUN apk add --no-cache openssl bash

COPY dhparam.pem.default /etc/nginx/dhparam/dhparam.pem.default
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY generate-dhparam.sh /usr/local/bin/generate-dhparam.sh
COPY nginx-default.conf.tmpl /etc/nginx/templates/nginx-default.conf.tmpl

WORKDIR /var/www/html

VOLUME ["/etc/nginx/dhparam"]

EXPOSE 80 443

LABEL name="wppier/wp-nginx"
LABEL version="latest"

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
