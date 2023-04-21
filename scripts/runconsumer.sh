#!/bin/bash
SCRIPTDIR=$(dirname $0)
source $SCRIPTDIR/env.vars
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
PIDS=$SCRIPTDIR/run

USAGE="USAGE: $0 { buy|sell|under_100|table_topic } "
STOCK_TYPE=$1
TOPIC_NAME="stocks_$STOCK_TYPE"
CONSUMER_OPTS="      $TOPIC_NAME \
                     --group confluent_cli_consumer_$STOCK_TYPE \
                     --config "client.id=consumer_stock_$STOCK_TYPE" \
                     --schema-registry-endpoint $SR_ENDPT \
                     --schema-registry-api-key $SR_KEY \
                     --schema-registry-api-secret ${SR_SECRET} \
                     --cluster $KAFKA_CLUSTER_ID \
                     --environment $ENV_ID \
                     --api-key $CONSUMER_KEY \
                     --api-secret ${CONSUMER_SECRET} \
                     --from-beginning \
                     --value-format avro \
                     --print-key \
                     "

case $STOCK_TYPE in
  under_100 | buy | sell | table_topic)
    CMD="confluent kafka topic consume $CONSUMER_OPTS"
    echo $CMD
    $CMD
    ;;

  *)
    echo $USAGE >&2
    ;;
esac
