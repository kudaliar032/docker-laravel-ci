FROM php:7.3-cli

RUN apt update \
  && apt install -yqq gpg \
    libpng-dev \
    libldb-dev \
    libldap2-dev \
    freetds-dev \
    imagemagick \
    libmagickwand-dev \
    libzip-dev \
    libc-client-dev \
    libkrb5-dev \
  && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
  && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
  && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a \
  && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
  && apt update \
  && ACCEPT_EULA=Y apt-get install -yqq msodbcsql17 \
    unixodbc-dev \
  && pecl install sqlsrv \
    pdo_sqlsrv \
    redis \
    imagick \
  && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
  && docker-php-ext-install gd pdo_mysql mysqli ldap pdo_dblib zip imap \
  && docker-php-ext-enable sqlsrv pdo_sqlsrv redis imagick \
  && curl -s https://getcomposer.org/installer | php -- --install-dir /usr/local/bin --filename=composer \
  && apt purge -y imagemagick gpg \
  && apt clean \
  && apt autoremove -y
