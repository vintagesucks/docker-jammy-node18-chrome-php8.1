FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt -y upgrade

# install essential packages
RUN apt-get -y install \
  curl \
  jq \
  build-essential \
  software-properties-common \
  language-pack-en-base \
  gconf-service \
  libasound2 \
  libgtk-3-0 \
  gconf-service \
  libasound2 \
  libgconf-2-4 \
  libnspr4 \
  libx11-dev \
  fonts-liberation \
  xdg-utils \
  libnss3 \
  libxss1 \
  libappindicator3-1 \
  libindicator3-7 \
  libgbm1 \
  git \
  zip \
  unzip \
  xvfb \
  wget

# add Node.js and PHP repos
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
  LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php && \
  apt-get update

# install Node.js and PHP
RUN apt-get -y install \
  nodejs \
  php8.1-fpm \
  php8.1-mbstring \
  php8.1-dom \
  php8.1-curl \
  php8.1-simplexml \
  php8.1-gd \
  php8.1-zip \
  php8.1-sqlite3 \
  php8.1-bcmath \
  php8.1-intl \
  php8.1-mysql

# enable Yarn
RUN corepack enable

# install Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
  --install-dir=/usr/local/bin --filename=composer

# install local-php-security-checker
RUN curl -L $(curl -s https://api.github.com/repos/fabpot/local-php-security-checker/releases/latest | \ 
  jq -r '.assets[].browser_download_url | select(.|test("_linux_amd64$"))') \ -o /usr/local/bin/local-php-security-checker && \ 
  chmod +x /usr/local/bin/local-php-security-checker

# test 
RUN local-php-security-checker

# install Google Chrome
RUN wget \
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
  dpkg -i google-chrome*.deb && \
  apt-get install -f && \
  rm google-chrome-stable_current_amd64.deb
