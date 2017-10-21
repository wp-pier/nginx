TODO: ipv6?

TODO: 500 error pages
```
# redirect server error pages to the static page /50x.html
#
error_page   500 502 503 504  /50x.html;
location = /50x.html {
    root   /usr/share/nginx/html;
}
```

TODO: additional headers (eg.Content-Security-Policy)

