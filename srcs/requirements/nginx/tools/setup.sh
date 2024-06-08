#!/bin/sh

# install dependencies
apk add --update --no-cache openssl curl ca-certificates nginx

# # set-up the apk repository for stable nginx packages
# printf "%s%s%s%s\n" \
#     "@nginx " \
#     "http://nginx.org/packages/alpine/v" \
#     `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
#     "/main" \
#     | tee -a /etc/apk/repositories \

# # import official nginx signing key
# curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub

# # mv the signing key to apk list of trusted keys
# mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/

# # update repos and install nginx
# apk add --no-cache nginx@nginx

# cd into work directory
# cd /usr/local/nginx

# # create a mount point directory for the volume
# mkdir html/

# create an ssl certificate
mkdir /etc/nginx/certs && cd /etc/nginx/certs && \
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/certs/test.crt \
	-keyout /etc/nginx/certs/key.key -subj "/C=US/ST=None/L=AbuDhabi/O=Certifie/CN=sabdelra.42.fr"
