#!/bin/bash
set -x
SCRIPTDIR=$(dirname $0)
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
mkdir -p $LOGDIR
NOW=$(date '+%Y-%m-%d:%H%M%S')

# get ksql-migrations properties
OUTFILE=$BASEDIR/ksql-governance-demo/ksql-migrations.properties
echo Creating $OUTFILE
if [ -s $OUTFILE ]; then
  mv $OUTFILE $OUTFILE.$NOW
fi

echo "# Created at $NOW" > $OUTFILE
terraform output -raw ksql-properties >> $OUTFILE
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
terraform output -raw tf-env >> $OUTFILE
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

echo "# Created at $NOW" > $OUTFILE
terraform output -raw jmx_monitor_env >> $OUTFILE
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

Next Steps:
1) Initialize ksql migrations:
ksql-migrations -c ksql-governance-demo/ksql-migrations.properties initialize-metadata

2) Create the ksql streams
ksql-migrations -c ksql-governance-demo/ksql-migrations.properties apply -v 1

3) Consume from each out of the output topics
scripts/runconsumer.sh under_100
scripts/runconsumer.sh buy
scripts/runconsumer.sh sell

4) Run the jmx-monitoring-stacks demo
git clone https://github.com/confluentinc/jmx-monitoring-stacks
Copy scripts/env_variables.env to jmx-monitoring-stacks/ccloud-prometheus-grafana/utils/env_variables.env
jmx-monitoring-stacks/ccloud-prometheus-grafana/start.sh
EOF