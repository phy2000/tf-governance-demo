#!/bin/bash
#set -x
SCRIPTDIR=$(dirname $0)
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
TFDIR=$BASEDIR/Terraform
RUNDIR=$SCRIPTDIR/run
TF_OPTIONS=$*

mkdir -p $RUNDIR
mkdir -p $LOGDIR
NOW=$(date '+%Y-%m-%d:%H%M%S')

# Do terraform apply
OUTFILE=$LOGDIR/apply.log
if [ -s $OUTFILE ]; then
  mv $OUTFILE $OUTFILE.$NOW
fi

echo "Output will be saved to $OUTFILE"
sleep 2
echo $NOW > $OUTFILE
confluent login --prompt
(terraform -chdir=$TFDIR apply -no-color $TF_OPTIONS; echo $? > $RUNDIR/apply.status) 2>&1 | tee -a $OUTFILE
SUCCESS=$(< $RUNDIR/apply.status)

if [ $SUCCESS -ne 0 ]; then
  echo "Terraform Failed - exiting..."
  exit $SUCCESS
fi
echo SUCCESS!

exit $SUCCESS
