#!/bin/bash

CLIENT_APP_PATH=~/shop-angular-cloudfront
CLIENT_APP_BUILD=$CLIENT_APP_PATH/dist/client-app.zip

if [ -e "$CLIENT_APP_BUILD" ]
then 
  rm $CLIENT_APP_BUILD
fi

if [ -z "$1" ]
then
  ENV_CONFIGURATION="production"
else
  ENV_CONFIGURATION=$1
fi

cd $CLIENT_APP_PATH 

npm install 
npm run build -- --configuration="$ENV_CONFIGURATION"

zip -r client-app.zip *
