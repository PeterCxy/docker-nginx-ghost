#!/bin/bash
export GHOST_NODE_VERSION_CHECK=false

if [[ $GHOST_SITE_HTTPS == true ]]; then
  sed -i "s@#https filtering@sub_filter 'http://${GHOST_SITE_URL}' 'https://${GHOST_SITE_URL}';@g" /etc/nginx/nginx.conf
fi

if [[ ! -z "$GHOST_SITE_DATA" ]]; then
  ln -s $GHOST_SITE_DATA /usr/src/ghost/content
fi

if [[ ! -d /usr/src/ghost/content || ! -d /usr/src/ghost/content/themes ]]; then
  mkdir -p /usr/src/ghost/content
  cp -R /usr/src/ghost/content_default/* /usr/src/ghost/content/
fi

nginx &
npm start --production
