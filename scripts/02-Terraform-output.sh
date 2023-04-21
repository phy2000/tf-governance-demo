#!/bin/bash
#set -x
SCRIPTDIR=$(dirname $0)
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
TFDIR=$BASEDIR/Terraform
RUNDIR=$SCRIPTDIR/run

mkdir -p $LOGDIR
NOW=$(date '+%Y-%m-%d:%H%M%S')

# get ksql-migrations properties
OUTFILE=$BASEDIR/ksql-governance-demo/ksql-migrations.properties
echo Creating $OUTFILE
if [ -s $OUTFILE ]; then
  mv $OUTFILE $OUTFILE.$NOW
fi

echo "# Created at $NOW" > $OUTFILE
terraform -chdir=$TFDIR output -raw ksql-properties >> $OUTFILE
SUCCESS=$?
if [ $SUCCESS -ne 0 ]; then
  echo "Create of $OUTFILE failed - exiting..."
  exit $SUCCESS
fi
echo SUCCESS!

# Create env.vars
OUTFILE=$SCRIPTDIR/env.vars
echo Creating $OUTFILE
if [ -s $OUTFILE ]; then
  mv $OUTFILE $OUTFILE.$NOW
fi

echo "# Created at $NOW" > $OUTFILE
terraform -chdir=$TFDIR output -raw tf-env >> $OUTFILE
SUCCESS=$?
if [ $SUCCESS -ne 0 ]; then
  echo "Create of $OUTFILE failed - exiting..."
  exit $SUCCESS
fi
echo SUCCESS!

# Create env_variables.env for jmx-monitoring-stacks
OUTFILE=$SCRIPTDIR/env_variables.env
echo Creating $OUTFILE
if [ -s $OUTFILE ]; then
  mv $OUTFILE $OUTFILE.$NOW
fi
echo -n "" > $RUNDIR/jmx-monitor-path.txt

echo "# Created at $NOW" > $OUTFILE
terraform -chdir=$TFDIR output -raw jmx_monitor_env >> $OUTFILE
SUCCESS=$?
if [ $SUCCESS -ne 0 ]; then
  echo "Create of $OUTFILE failed - exiting..."
  exit $SUCCESS
fi
echo SUCCESS!

cat <<EOF
These output files have been created:
  - ksql-governance-demo/ksql-migrations.properties
  - scripts/env.vars
  - scripts/env_variables.env
EOF