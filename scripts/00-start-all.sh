#!/bin/bash

SCRIPTDIR=$(dirname $0)
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
PIDS=$SCRIPTDIR/run

APPLY_OPTS="$*"
if ! confluent env list > /dev/null 2>&1 ; then
  echo -e "Run confluent login before continuing\nExiting..." >&2
  exit 1
fi

echo "###########################"
echo "# Terraform apply $APPLY_OPTS"
echo "###########################"
$SCRIPTDIR/01-Terraform-apply.sh $APPLY_OPTS
if [ $? -ne 0 ] ; then
    echo ERROR...Exiting
    exit 1
fi

echo "###########################"
echo "# Terraform output"
echo "###########################"
$SCRIPTDIR/02-Terraform-output.sh
if [ $? -ne 0 ] ; then
    echo ERROR...Exiting
    exit 1
fi

echo "###########################"
echo "# ksql-migrations "
echo "###########################"
$SCRIPTDIR/03-ksql-migrations.sh
if [ $? -ne 0 ] ; then
    echo ERROR...Exiting
    exit 1
fi

echo "###########################"
echo "# Run Consumers"
echo "###########################"
$SCRIPTDIR/04-runconsumers.sh
if [ $? -ne 0 ] ; then
    echo ERROR...Exiting
    exit 1
fi

echo "###########################"
echo "# JMX Monitoring Stacks "
echo "###########################"
$SCRIPTDIR/05-run-monitoring-demo.sh
if [ $? -ne 0 ] ; then
    echo ERROR...Exiting
    exit 1
fi
