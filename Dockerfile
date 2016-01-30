FROM base/archlinux:2015.06.01
MAINTAINER Peter Cai <peter@typeblog.net>

# Set the mirror
RUN echo 'Server = http://mirror.rackspace.com/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

# Initialize the environment
RUN pacman -Syyu --noconfirm
RUN pacman -S --noconfirm base-devel nodejs npm wget unzip git

# Install nginx-devel
WORKDIR /usr/src/ghost
RUN echo 'nobody ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN git clone https://aur.archlinux.org/psol.git && \
  chmod -R 777 /usr/src/ghost/psol && \
  cd /usr/src/ghost/psol && \
  sudo -u nobody makepkg -sci --noconfirm
RUN git clone https://aur.archlinux.org/nginx-devel.git && \
  chmod -R 777 /usr/src/ghost/nginx-devel && \
  cd /usr/src/ghost/nginx-devel && \
  sudo -u nobody makepkg -sci --noconfirm

# Now remove the sudo program for security
RUN pacman -R --noconfirm sudo

# Populate basic Ghost environment
RUN  wget https://github.com/PeterCxy/Ghost/releases/download/0.7.5-master-20160130/release.zip && \
  unzip release.zip && \
  sed -i 's/preinstall/hhh/g' package.json && \
  npm install --production && \
  mv content content_default

# Install the Configuration
COPY config.js /usr/src/ghost/
COPY nginx.conf /etc/nginx/
COPY run.sh /usr/src/ghost/
RUN chmod +x run.sh

EXPOSE 80
CMD ["./run.sh"]
