#!/bin/bash
SCRIPTDIR=$(dirname $0)
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
PIDS=$SCRIPTDIR/run

mkdir -p $LOGDIR
#NOW=$(date '+%Y-%m-%d:%H%M%S')

if [ $# -ge 1 ]; then
  DESTDIR=$1
else
  echo -n "Enter path to jmx-monitoring-stacks: "
  read DESTDIR
fi

for topic in under_100 buy sell; do
  killpid = $(<$PIDS/$topic.pid)
  echo Killing consumer for $topic: $killpid
  kill $killpid
done


if [ ! -d $DESTDIR/ccloud-prometheus-grafana/ ]; then
  echo $DESTDIR is not a valid jmx-monitoring-stacks directory >&2
  echo To end the monitoring demo, run ccloud-prometheus-grafana/stop.sh
fi

echo Destroying the cloud assets
terraform destroy -auto-approve
echo terraform destroy complete

echo stopping the monitoring demo
$DESTDIR/ccloud-prometheus-grafana/stop.sh
