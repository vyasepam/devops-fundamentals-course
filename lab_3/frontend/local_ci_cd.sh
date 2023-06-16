#!/bin/bash

npm run lint

npm run test

npm audit

CLIENT_REMOTE_DIR=/var/www/myshop

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

check_remote_dir_exists $CLIENT_REMOTE_DIR

echo "---> Building and transfering client files - START <---"

npm install

if [ "$ENV_CONFIGURATION" = "production" ]; then
  npm run build -- --configuration=production
else
  npm run build
fi

export ENV_CONFIGURATION="${ENV_CONFIGURATION:-development}"

scp -Cr dist/* ubuntu-sshuser:$CLIENT_REMOTE_DIR

echo "---> Building and transfering - COMPLETE <---"