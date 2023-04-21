#!/bin/bash
SCRIPTDIR=$(dirname $0)
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
RUNDIR=$SCRIPTDIR/run
mkdir -p $LOGDIR
#NOW=$(date '+%Y-%m-%d:%H%M%S')

if [ $# -ge 1 ]; then
  DESTDIR=$1
else
  if ! read -t 15 -e -p "Enter path to jmx-monitoring-stacks: " DESTDIR; then
    echo Timed out - exiting...
    exit 1
  fi
fi

if [ ! -d $DESTDIR/ccloud-prometheus-grafana/utils/ ]; then
  echo $DESTDIR is not a valid jmx-monitoring-stacks directory >&2
  echo Exiting ... >&2
  exit -1
fi

DESTDIR=$(cd $DESTDIR && pwd)
echo $DESTDIR > $RUNDIR/jmx-monitor-path.txt
cp $SCRIPTDIR/env_variables.env $DESTDIR/ccloud-prometheus-grafana/utils
$DESTDIR/ccloud-prometheus-grafana/start.sh
