#!/bin/bash
export GHOST_NODE_VERSION_CHECK=false

if [[ $GHOST_SITE_HTTPS == true ]]; then
  sed -i "s@#https filtering@sub_filter 'http://${GHOST_SITE_URL}' 'https://${GHOST_SITE_URL}';@g" /etc/nginx/nginx.conf
fi

nginx &
npm start --production
