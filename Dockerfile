############################################
# Base Image
############################################

# Learn more about the Server Side Up PHP Docker Images at:
# https://serversideup.net/open-source/docker-php/
#FROM serversideup/php:8.3-fpm-nginx-v3.3.0 AS base
FROM serversideup/php:8.3-fpm-nginx-v3.4.5  AS base
# Switch to root before installing our PHP extensions
USER root
RUN install-php-extensions intl gd xsl
RUN apt update && apt install -y default-mysql-client

# Switch back to the unprivileged www-data user
USER www-data

############################################
# Development Image
############################################
FROM base AS development

# We can pass USER_ID and GROUP_ID as build arguments
# to ensure the www-data user has the same UID and GID
# as the user running Docker.
ARG USER_ID=1000
ARG GROUP_ID=1000

# Switch to root so we can set the user ID and group ID
USER root
RUN docker-php-serversideup-set-id www-data $USER_ID:$GROUP_ID  && \
    docker-php-serversideup-set-file-permissions --owner $USER_ID:$GROUP_ID --service nginx

# Switch back to the unprivileged www-data user
USER www-data

############################################
# CI image
############################################
FROM serversideup/php:8.3-cli AS ci

# Sometimes CI images need to run as root
# so we set the ROOT user and configure
# the PHP-FPM pool to run as www-data
USER root

RUN install-php-extensions intl gd xsl pcov

FROM base AS copy

WORKDIR /var/www/html

# Copy only composer files to leverage Docker layer caching
#COPY composer.* /var/www/html/

COPY --chown=www-data:www-data composer.* /var/www/html/
RUN chmod 664 /var/www/html/composer.json


RUN composer install --no-dev --no-interaction --no-autoloader --no-scripts

#RUN composer require laravel/telescope

#RUN composer require laravel/telescope
# Copy the rest of the application
COPY --chown=www-data:www-data . /var/www/html
RUN rm -rf tests/

RUN composer dump-autoload --optimize

############################################
# Production Image
############################################
FROM base AS deploy
#ENV S6_CMD_WAIT_FOR_SERVICES=3

# Node Exporter
#COPY --from=quay.io/prometheus/node-exporter:latest --chown=www-data:www-data /bin/node_exporter /usr/local/bin/node_exporter

#COPY --chmod=755 ./.docker/entrypoint.d/ /etc/entrypoint.d/

COPY --from=copy /var/www/html /var/www/html

#RUN composer require livewire/livewire

#RUN composer require filament/filament:"^3.2" -W && \
     #php artisan filament:install --panels

#COPY nginx.conf /etc/nginx/
# Change to root, so we can do root things
USER root

#RUN docker-php-serversideup-s6-init

USER www-data

#ENTRYPOINT ["sh", "-c", "service nginx start && php-fpm && sleep 100"]

