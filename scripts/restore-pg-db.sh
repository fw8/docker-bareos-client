#!/bin/bash

# Be backwards compatible
if [ ! -z $POSTGRESQL_RESTORE_PATH ]
then
    BAREOS_PG_RESTORE_PATH=$POSTGRESQL_RESTORE_PATH
fi

# Restore db from pipe
if [ ! -z $BAREOS_PG_RESTORE_PATH ]
then
    gzip --best </dev/stdin >$BAREOS_PG_RESTORE_PATH/$1.sql.gz
else
    psql $1 < /dev/stdin
fi

exit 0