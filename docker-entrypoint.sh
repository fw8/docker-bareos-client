#!/usr/bin/env bash

if [ ! -f /etc/bareos/bareos-config.control ]
  then
  tar xfvz /bareos-fd.tgz

  # Force client/file daemon password
  sed -i "s#Password = .*#Password = \"${BAREOS_FD_PASSWORD}\"#" /etc/bareos/bareos-fd.d/director/bareos-dir.conf

  # Be backwards compatible
  if [ ! -z $MYSQL_ADMIN_USER ]
  then
      BAREOS_MYSQL_USER=$MYSQL_ADMIN_USER
  fi
  if [ ! -z $MYSQL_ADMIN_PASSWORD ]
  then
      BAREOS_MYSQL_PASSWORD=$MYSQL_ADMIN_PASSWORD
  fi
  if [ ! -z $MYSQL_HOST ]
  then
      BAREOS_MYSQL_HOST=$MYSQL_HOST
  fi

  # Setup PG-Environment
  if [ ! -z $BAREOS_PG_USER ]
  then
      export PGUSER=$BAREOS_PG_USER
  fi
  if [ ! -z $BAREOS_PG_PASSWORD ]
  then
      export PGPASSWORD=$BAREOS_PG_PASSWORD
  fi
  if [ ! -z $BAREOS_PG_HOST ]
  then
      export PGHOST=$BAREOS_PG_HOST
  fi

  # Setup MySQL-Environment
  echo "[client]" > /etc/mysql/conf.d/client.cnf

  if [ ! -z $BAREOS_MYSQL_USER ]
  then
      echo "user=$BAREOS_MYSQL_USER" >> /etc/mysql/conf.d/client.cnf
  else
    echo "user=root" >> /etc/mysql/conf.d/client.cnf
  fi

  if [ ! -z $BAREOS_MYSQL_PASSWORD ]
  then
    echo "password=$BAREOS_MYSQL_PASSWORD" >> /etc/mysql/conf.d/client.cnf
  fi

  if [ ! -z $BAREOS_MYSQL_HOST ]
  then
      echo "host=$BAREOS_MYSQL_HOST" >> /etc/mysql/conf.d/client.cnf
  else
    echo "host=db" >> /etc/mysql/conf.d/client.cnf
  fi

  # Control file
  touch /etc/bareos/bareos-config.control
fi

find /etc/bareos/bareos-fd.d ! -user bareos -exec chown bareos {} \;
exec "$@"
