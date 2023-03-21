#!/bin/bash

CLIENT_APP_PATH=~/shop-angular-cloudfront

cd $CLIENT_APP_PATH

npm run lint

npm audit

npm run e2e

if [ $? -eq 0 ]
then
  echo "Successfully"
else
  echo "Failed"
fi
