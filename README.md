# Ping!

The live website for Ping!
This website is designed to be served with on nginx, where live requests are being visualised on a live log.

## Wildcard URL page

For local test:
run `npx live-server --entry-file=wildcard/index.html`

For nginx setup:

update the following in `/etc/nginx/sites-available/<file-name>.conf`

```
location / {
    try_files $uri $uri/ /wildcard/index.html;
}

# optional: missing assets should return a real 404, not the HTML page
location ~ ^/(assets|css|js)/ {
    try_files $uri =404;
}
```

run the follow script after changing the config

```
sudo nginx -t
sudo systemctl reload nginx
```
