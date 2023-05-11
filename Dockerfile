FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y

# install essential packages
RUN apt install -y \
  curl \
  git \
  gpg \
  software-properties-common \
  wget \
  xvfb

# add Node.js, PHP and ImageMagick repos
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN wget -qO - https://vintagesucks.github.io/ppa/key.gpg | gpg --dearmor -o /usr/share/keyrings/vintagesucks-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/vintagesucks-keyring.gpg] https://vintagesucks.github.io/ppa/ubuntu/jammy ./" | tee /etc/apt/sources.list.d/vintagesucks-jammy.list

# install ImageMagick, Node.js and PHP
RUN apt update && apt install -y \
  imagemagick \
  nodejs \
  php8.1-bcmath \
  php8.1-curl \
  php8.1-dev \
  php8.1-dom \
  php8.1-fpm \
  php8.1-gd \
  php8.1-intl \
  php8.1-mbstring \
  php8.1-mysql \
  php8.1-simplexml \
  php8.1-sqlite3 \
  php8.1-zip

# enable Yarn
RUN corepack enable

# install Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
  --install-dir=/usr/local/bin --filename=composer

# install Imagick
RUN curl -o imagick.tgz https://pecl.php.net/get/imagick && \
  printf "\n" | MAKEFLAGS="-j $(nproc)" pecl upgrade --force ./imagick.tgz && \
  rm imagick.tgz && \
  echo 'extension=imagick.so' > /etc/php/8.1/mods-available/imagick.ini && \
  phpenmod imagick && \
  # smoke test
  php -r 'phpinfo();' | grep -i "ImageMagick"

# install Google Chrome
RUN curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb
