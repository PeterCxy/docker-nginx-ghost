FROM node:argon
MAINTAINER Peter Cai <peter@typeblog.net>

# Install unzip
RUN apt-get update
RUN apt-get -y install unzip

# Install nginx
ENV NGINX_VERSION 1.9.10-1~jessie
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y ca-certificates nginx=${NGINX_VERSION} gettext-base \
	&& rm -rf /var/lib/apt/lists/*

# Group nobody
RUN groupadd nobody && gpasswd -a nobody nobody

# Populate basic Ghost environment
WORKDIR /usr/src/ghost
ENV GHOST_REL 0.7.5-master-20160203
RUN  wget https://github.com/PeterCxy/Ghost/releases/download/${GHOST_REL}/release.zip && \
  unzip release.zip && \
  npm install --production && \
  mv content content_default

# Install the Configuration
COPY config.js /usr/src/ghost/
COPY nginx.conf /etc/nginx/
COPY run.sh /usr/src/ghost/
RUN chmod +x run.sh

EXPOSE 80
CMD ["./run.sh"]
