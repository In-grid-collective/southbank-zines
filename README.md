# Ping!

The live website for Ping!
This website is designed to be served with on nginx, where live requests are being visualised on a live log.

## Example nginx config

an example for the log settings in nginx config is in `nginx/log-nginx.conf`, which shows the redacted log format

## Image and PDF assets

Large storage files such as images and pdf are excluded from git.

To update media asset, manually put content in
`assets/images`, `assets/zines`, and `assets/thumbs`, which are added to the `.gitignore`

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
