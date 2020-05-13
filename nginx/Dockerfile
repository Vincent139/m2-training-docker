FROM nginx:1.14-alpine

RUN mkdir /etc/nginx/ssl
COPY ./files/etc/nginx/ssl/formation.local.crt /etc/nginx/ssl/formation.local.crt
COPY ./files/etc/nginx/ssl/formation.local.key /etc/nginx/ssl/formation.local.key
COPY ./files/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
