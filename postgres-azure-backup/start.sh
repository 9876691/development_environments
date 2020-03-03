#!/bin/bash

if [ "${POSTGRES_HOST}" = "" ]; then
  if [ -n "${POSTGRES_PORT_5432_TCP_ADDR}" ]; then
    POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
    POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
  else
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
  fi
fi

if [ "${POSTGRES_USER}" = "" ]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [ "${POSTGRES_PASSWORD}" = "" ]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable or link to a container named POSTGRES."
  exit 1
fi

if [ -n $POSTGRES_PASSWORD ]; then
    export PGPASSWORD=$POSTGRES_PASSWORD
fi

if [ "$1" == "backup" ]; then
    if [ -n "$2" ]; then
        databases=$2
    else
        databases=`psql --username=$POSTGRES_USER --host=$POSTGRES_HOST --port=$POSTGRES_PORT -l | grep "UTF8" | grep -Ev "(template[0-9]*)" | awk '{print $1}'`
    fi

    for db in $databases; do
        echo "dumping $db"

        # -Fc the postgres compressed format.
        pg_dump -Fc --host=$POSTGRES_HOST --port=$POSTGRES_PORT --username=$POSTGRES_USER $db > "/tmp/$db.dump"

        ls -la "/tmp/$db.tar.gz"

        DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`

        if [ $? == 0 ]; then
            az storage blob upload -f /tmp/$db.dump -c $AZURE_STORAGE_CONTAINER -n "${db}_${DATE_WITH_TIME}.dump" --connection-string "DefaultEndpointsProtocol=https;BlobEndpoint=https://$AZURE_STORAGE_ACCOUNT.blob.core.windows.net/;AccountName=$AZURE_STORAGE_ACCOUNT;AccountKey=$AZURE_STORAGE_ACCESS_KEY"

            if [ $? == 0 ]; then
                rm /tmp/$db.dump
            else
                >&2 echo "couldn't transfer $db.dump to Azure"
            fi
        else
            >&2 echo "couldn't dump $db"
        fi
    done
elif [ "$1" == "restore" ]; then
    # Not tested yet.
    if [ -n "$2" ]; then
        archives=$2

        for archive in $archives; do
            tmp=/tmp/$archive

            echo "restoring $archive"
            echo "...transferring"

            az storage blob upload  download  -c $AZURE_STORAGE_CONTAINER -n "${db}_${DATE_WITH_TIME}.dump" --connection-string "DefaultEndpointsProtocol=https;BlobEndpoint=https://$AZURE_STORAGE_ACCOUNT.blob.core.windows.net/;AccountName=$AZURE_STORAGE_ACCOUNT;AccountKey=$AZURE_STORAGE_ACCESS_KEY" $archive $tmp

            if [ $? == 0 ]; then
                echo "...restoring"
                pg_restore --clean --host=$POSTGRES_HOST --port=$POSTGRES_PORT --username=$POSTGRES_USER $tmp
            else
                rm $tmp
            fi
        done
    else
        >&2 echo "You must provide the name of the blob to restore"
    fi
else
    >&2 echo "You must provide either backup or restore to run this container"
    exit 64
fi