#!/bin/bash

LOCAL_SERVER_DIR=$(pwd)/backend
LOCAL_CLIENT_DIR=$(pwd)/frontend

REMOTE_SERVER_DIR=/var/app/myshop
REMOTE_CLIENT_DIR=/var/www/myshop

check_remote_dir_exists() {
  echo "Check if remote directories exist"

  if ssh ubuntu-sshuser "[ ! -d $1 ]"; then
    echo "Creating: $1"
	ssh -t ubuntu-sshuser "sudo bash -c 'mkdir -p $1 && chown -R sshuser: $1'"
  else
    echo "Clearing: $1"
    ssh ubuntu-sshuser "sudo -S rm -r $1/*"
  fi
}

check_remote_dir_exists $REMOTE_SERVER_DIR
check_remote_dir_exists $REMOTE_CLIENT_DIR

echo "---> Building and copying server files - START <---"
echo $LOCAL_SERVER_DIR
cd $LOCAL_SERVER_DIR
scp -Cr dist/* package.json ubuntu-sshuser:$REMOTE_SERVER_DIR
echo "---> Building and transfering server - COMPLETE <---"

echo "---> Building and transfering client files - START <---"
echo $LOCAL_CLIENT_DIR
cd $LOCAL_CLIENT_DIR && npm run build && cd ../
scp -Cr $LOCAL_CLIENT_DIR/dist/app/* ubuntu-sshuser:$REMOTE_CLIENT_DIR
echo "---> Building and transfering - COMPLETE <---"

echo "---> Starting nginx and backend app on server - START <---"
ssh ubuntu-sshuser  "systemctl start nginx"
ssh ubuntu-sshuser "cd $REMOTE_SERVER_DIR && npm i && pm2 start main.js"
echo "---> Services have been started <---"
