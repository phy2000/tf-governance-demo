#!/bin/bash
SCRIPTDIR=$(dirname $0)
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
mkdir -p $LOGDIR
#NOW=$(date '+%Y-%m-%d:%H%M%S')

if [ $# -ge 1 ]; then
  DESTDIR=$1
else
  echo -n "Enter path to jmx-monitoring-stacks: "
  read DESTDIR
fi

if [ ! -d $DESTDIR/ccloud-prometheus-grafana/utils/ ]; then
  echo $DESTDIR is not a valid jmx-monitoring-stacks directory >&2
  echo Exiting ... >&2
  exit -1
fi

cp $SCRIPTDIR/env_variables.env $DESTDIR/ccloud-prometheus-grafana/utils
$DESTDIR/ccloud-prometheus-grafana/start.sh
