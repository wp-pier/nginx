# wppier/nginx

Set a `SERVER_NAME` environment variable to define a hostname otherwise `localhost` is assumed.

You need to tell `nginx` where it's SSL file is using the following environment variables:
```
SSL_CRT_FILE
SSL_KEY_FILE
SSL_CHAIN_FILE
```
You can then mount the actual files using Docker Swarm Secrets, a shared volume
or other method of your choice.

If you don't specify a location this image assumes you have a shared Letsencrypt volume at
`/etc/letsencrypt` and it will look for certs for the defined `SERVER_NAME`

A unique dhparam file will be generated you can specify your own by mounting it at
`/etc/nginx/dhparam/dhparam.pem`

If necessary define the upstream php server with `WORDPRESS_UPSTREAM` which defaults to
`wp-fpm`
