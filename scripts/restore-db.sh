#!/bin/bash

# Restore db from pipe
if [ ! -z $MYSQL_RESTORE_PATH ]
  then
    gzip --best </dev/stdin >$MYSQL_RESTORE_PATH/$1.sql.gz
  else
    mysql < /dev/stdin
  fi

exit 0