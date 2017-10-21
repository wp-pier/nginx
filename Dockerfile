FROM wppier/confd:latest as confd

FROM nginx:mainline-alpine

LABEL name="wppier/nginx"
LABEL version="0.0.1"

COPY --from=confd /usr/local/bin/confd /usr/local/bin/confd

RUN apk add --no-cache openssl bash

# Copy all needed files
COPY /files/ /

WORKDIR /var/www/html

VOLUME ["/etc/nginx/dhparam"]

EXPOSE 80 443

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
