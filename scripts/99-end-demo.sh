#!/bin/bash
SCRIPTDIR=$(dirname $0)
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
TFDIR=$BASEDIR/Terraform
RUNDIR=$SCRIPTDIR/run
TF_OPTIONS=$*

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

DESTDIR=$(< $RUNDIR/jmx-monitor-path.txt) 2> /dev/null

for _TYPE in under_100 buy sell; do
  topic=stocks_$_TYPE
  echo Killing consumer for $topic
  pkill -l -f "confluent kafka topic consume $topic"
done

sleep 2

if [ ! -z "$DESTDIR" ] ; then
    echo stopping the monitoring demo
    if [ ! -d $DESTDIR/ccloud-prometheus-grafana/ ]; then
      echo "\"$DESTDIR\"" is not a valid jmx-monitoring-stacks directory >&2
      echo To end the monitoring demo, run ccloud-prometheus-grafana/stop.sh
    else
        $DESTDIR/ccloud-prometheus-grafana/stop.sh
    fi
fi


echo Destroying the cloud assets
sleep 2
(terraform -chdir=$TFDIR destroy -no-color $TF_OPTIONS; echo $? > $RUNDIR/destroy.status ) 2>&1 \
    | tee -a $OUTFILE
SUCCESS=$(<$RUNDIR/destroy.status)

if [ $SUCCESS -ne 0 ]; then
  echo "Terraform Failed - exiting..."
  exit $SUCCESS
fi
echo SUCCESS!
echo terraform destroy complete
exit $SUCCESS
