FROM node:argon
MAINTAINER Peter Cai <peter@typeblog.net>

# Install nginx
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y ca-certificates nginx=${NGINX_VERSION} gettext-base \
	&& rm -rf /var/lib/apt/lists/*

# Populate basic Ghost environment
WORKDIR /usr/src/ghost
RUN  wget https://github.com/PeterCxy/Ghost/releases/download/0.7.5-master-20160203/release.zip && \
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
