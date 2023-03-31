#!/bin/bash
SCRIPTDIR=$(dirname $0)
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
mkdir -p $LOGDIR
#NOW=$(date '+%Y-%m-%d:%H%M%S')

echo Initialize ksql migrations:
ksql-migrations -c $BASEDIR/ksql-governance-demo/ksql-migrations.properties initialize-metadata

echo -n waiting 5 seconds for topics...
sleep 5
echo done

echo Create the ksql streams
ksql-migrations -c $BASEDIR/ksql-governance-demo/ksql-migrations.properties apply -v 1
