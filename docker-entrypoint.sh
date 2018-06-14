#!/usr/bin/env bash

if [ ! -f /etc/bareos/bareos-config.control ]
  then
  tar xfvz /bareos-fd.tgz

  # Force client/file daemon password
  sed -i "s#Password = .*#Password = \"${BAREOS_FD_PASSWORD}\"#" /etc/bareos/bareos-fd.d/director/bareos-dir.conf

  echo "[client]" > /etc/mysql/conf.d/client.cnf

  if [ ! -z $MYSQL_ADMIN_USER ]
  then
      echo "user=$MYSQL_ADMIN_USER" >> /etc/mysql/conf.d/client.cnf
  else
    echo "user=root" >> /etc/mysql/conf.d/client.cnf
  fi

  if [ ! -z $MYSQL_ADMIN_PASSWORD ]
  then
    echo "password=$MYSQL_ADMIN_PASSWORD" >> /etc/mysql/conf.d/client.cnf
  fi

  if [ ! -z $MYSQL_HOST ]
  then
      echo "host=$MYSQL_HOST" >> /etc/mysql/conf.d/client.cnf
  else
    echo "host=db" >> /etc/mysql/conf.d/client.cnf
  fi

  # Control file
  touch /etc/bareos/bareos-config.control
fi

find /etc/bareos/bareos-fd.d ! -user bareos -exec chown bareos {} \;
exec "$@"
