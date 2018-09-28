#!/bin/bash

# Restore db from pipe
if [ ! -z $POSTGRESQL_RESTORE_PATH ]
  then
    gzip --best </dev/stdin >$POSTGRESQL_RESTORE_PATH/$1.sql.gz
  else
    psql $1 < /dev/stdin
  fi

exit 0