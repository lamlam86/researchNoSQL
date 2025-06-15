FROM node:dubnium-alpine

# ENV
ENV APP_USER mongodb
ENV APP_PORT 3000

RUN addgroup -S -g 1234 mongodb && adduser -S -G mongodb -u 1234 mongodb \
    && set -ex \
    && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/main' >> /etc/apk/repositories \
    && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/community' >> /etc/apk/repositories \
    && apk update

RUN apk add --no-cache mongodb=3.4.4-r0 bash

# SET challenges
ADD ./deploy /app
WORKDIR /app

RUN mkdir -p /data/db && chown mongodb:mongodb /data/db
RUN npm install --global npm && mv docker-entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh

USER $APP_USER
EXPOSE $APP_PORT

# RUN
ENTRYPOINT ["docker-entrypoint.sh"]
