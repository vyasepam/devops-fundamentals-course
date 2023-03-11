SPACE_LIMIT_GB=100

if [ $# -gt 0 ]; then
  SPACE_LIMIT_GB=$1
fi

while true
do
  FREE_SPACE=$(df -h / | awk '/\// {print $4}')

  FREE_SPACE=${FREE_SPACE%G}
  FREE_SPACE=${FREE_SPACE%.*}

  if [ "$FREE_SPACE" -lt "$SPACE_LIMIT_GB" ]
  then
    echo "INFO: Your disk space is below ${SPACE_LIMIT_GB} GB. ${FREE_SPACE} GB left!"
  fi

  sleep 30s
done
