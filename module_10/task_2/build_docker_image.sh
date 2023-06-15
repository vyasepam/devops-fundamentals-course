#!/bin/bash

app_image=vryasepam/nestjs-app-v1

docker build . -t $app_image
docker push $app_image
echo "finished"