#!/bin/bash

# Be backwards compatible
if [ ! -z $MYSQL_RESTORE_PATH ]
then
    BAREOS_MYSQL_RESTORE_PATH=$MYSQL_RESTORE_PATH
fi

# Restore db from pipe
if [ ! -z $BAREOS_MYSQL_RESTORE_PATH ]
  then
    gzip --best </dev/stdin >$BAREOS_MYSQL_RESTORE_PATH/$1.sql.gz
  else
    mysql < /dev/stdin
  fi

exit 0