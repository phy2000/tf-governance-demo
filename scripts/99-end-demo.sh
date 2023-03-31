#!/bin/bash
SCRIPTDIR=$(dirname $0)
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
PIDS=$SCRIPTDIR/run

mkdir -p $LOGDIR
NOW=$(date '+%Y-%m-%d:%H%M%S')

# Do terraform apply
OUTFILE=$LOGDIR/destroy.log
if [ -s $OUTFILE ]; then
  mv $OUTFILE $OUTFILE.$NOW
fi

echo "Output will be saved to $OUTFILE"
sleep 2
echo $NOW > $OUTFILE

if [ $SUCCESS -ne 0 ]; then
  echo "Terraform Failed - exiting..."
  exit $SUCCESS
fi
echo SUCCESS!

if [ $# -ge 1 ]; then
  DESTDIR=$1
else
  echo -n "Enter path to jmx-monitoring-stacks: "
  read DESTDIR
fi

for _TYPE in under_100 buy sell; do
  topic=stocks_$_TYPE
  echo Killing consumer for $topic
  pkill -l -f "confluent kafka topic consume $topic"
done

sleep 2

if [ ! -d $DESTDIR/ccloud-prometheus-grafana/ ]; then
  echo $DESTDIR is not a valid jmx-monitoring-stacks directory >&2
  echo To end the monitoring demo, run ccloud-prometheus-grafana/stop.sh
fi


echo stopping the monitoring demo
$DESTDIR/ccloud-prometheus-grafana/stop.sh

echo Destroying the cloud assets
sleep 2
terraform destroy -no-color 2>&1 | tee -a $OUTFILE
SUCCESS=$?
if [ $SUCCESS -ne 0 ]; then
  echo "Terraform Failed - exiting..."
  exit $SUCCESS
fi
echo SUCCESS!
echo terraform destroy complete
