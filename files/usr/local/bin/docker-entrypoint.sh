#!/bin/sh
set -eu

if [ "${SSL_CRT_FILE:-NOTSET}" = "NOTSET" ];
then
  export SSL_CRT_FILE="/etc/letsencrypt/live/${SERVER_NAME:-localhost}/fullchain.pem"
fi

if [ "${SSL_KEY_FILE:-NOTSET}" = "NOTSET" ];
then
  export SSL_KEY_FILE="/etc/letsencrypt/live/${SERVER_NAME:-localhost}/privatekey.pem"
fi

if [ "${SSL_CHAIN_FILE:-NOTSET}" = "NOTSET" ];
then
  export SSL_CHAIN_FILE="/etc/letsencrypt/live/${SERVER_NAME:-localhost}/chain.pem"
fi

triesRemaining=10;
while [ ! -f ${SSL_CRT_FILE} ] || [ ! -f ${SSL_KEY_FILE} ] || [ ! -f ${SSL_CHAIN_FILE} ]
do
  triesRemaining="$((triesRemaining-1))";
  if [ "$triesRemaining" -lt 0 ];
  then
    echo "You need certs to run! Quiting...";
    exit 1 ;
  fi
  echo "Certs don't exist yet. Waiting (${triesRemaining})...";
  sleep 3;
done;

# Compute the DNS resolvers for use in the templates - if the IP contains ":", it's IPv6 and must be enclosed in []
export RESOLVERS=$(awk '$1 == "nameserver" {print ($2 ~ ":")? "["$2"]": $2}' ORS=' ' /etc/resolv.conf | sed 's/ *$//g')
if [ "x$RESOLVERS" = "x" ]; then
    echo "Warning: unable to determine DNS resolvers for nginx" >&2
    unset RESOLVERS
fi

generate-dhparam.sh ${DHPARAM_BITS:-4096} ${DHPARAM_USEDSA:-true}


confd -onetime -backend env

exec "$@"
