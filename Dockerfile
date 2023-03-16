FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y

# install essential packages
RUN apt install -y \
  curl \
  git \
  software-properties-common \
  xvfb

# add Node.js and PHP repos
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php

# install Node.js and PHP
RUN apt update && apt install -y \
  nodejs \
  php8.1-bcmath \
  php8.1-curl \
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

# install Google Chrome
RUN curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb
