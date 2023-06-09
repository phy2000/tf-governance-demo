#!/bin/bash
SCRIPTDIR=$(dirname $0)
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
PIDS=$SCRIPTDIR/run
mkdir -p $LOGDIR
#NOW=$(date '+%Y-%m-%d:%H%M%S')

mkdir -p $PIDS

# Make sure the CLI is logged in, else the timing gets whack
if ! confluent env list > /dev/null 2>&1 ; then
  echo -e "Run confluent login before continuing\nExiting..." >&2
  exit 1
fi

echo Running Topic Consumers
echo Consume from under_100 topic
sleep 1
$SCRIPTDIR/runconsumer.sh under_100 > $LOGDIR/under_100.out &
echo Consume from buy topic
sleep 1
$SCRIPTDIR/runconsumer.sh buy > $LOGDIR/buy.out &
sleep 1
echo Consume from sell topic
$SCRIPTDIR/runconsumer.sh sell > $LOGDIR/sell.out &

