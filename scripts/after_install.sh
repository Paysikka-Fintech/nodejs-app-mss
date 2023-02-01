#!/bin/bash

APP_DIR=/var/www/html/application
HOSTNAME=__SERVER_HOSTNAME__
APP_VERSION=__VERSION__
ENV=__ENV__

#########################################
######### LARAVEL CONFIGURATION #########
#########################################

chmod -R 777 $APP_DIR/storage
chmod -R 777 $APP_DIR/bootstrap/cache

#########################################
############### Build ENV ###############
#########################################

cp $APP_DIR/.github/deployment/server/.env $APP_DIR/.env
sed -i "s/__VERSION__/$VERSION/g" $APP_DIR/.env
sh $APP_DIR/.github/deployment/server/AwsSecrets.sh $ENV/$HOSTNAME $APP_DIR/.env

cd $APP_DIR && php artisan optimize && php artisan config:clear

#cd $APP_DIR && php artisan config:clear | fails if this is enabled
cd $APP_DIR && php artisan route:cache
cd $APP_DIR && php artisan view:cache

##### Migration
cd $APP_DIR && php artisan migrate --force

#########################################
############# NGNIX SERVER ##############
#########################################
rm -rf /etc/nginx/sites-available/default
rm -rf /etc/nginx/sites-enabled/default
cp $APP_DIR/.github/deployment/server/laravel.conf /etc/nginx/conf.d/laravel.conf
