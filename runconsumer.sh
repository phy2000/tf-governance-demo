#!/bin/bash
source env.vars

USAGE="USAGE: $0 { buy|sell|under_100 } "
STOCK_GROUP=$1
TOPIC_NAME="stocks_$STOCK_GROUP"
CONSUMER_OPTS="      $TOPIC_NAME \
                      --group confluent_cli_consumer_$STOCK_GROUP
                     --from-beginning \
                     --schema-registry-endpoint $SR_ENDPT \
                     --schema-registry-api-key $SR_KEY \
                     --schema-registry-api-secret \"$SR_SECRET\" \
                     --value-format avro
                     --from-beginning --environment $ENV_ID \
                     --cluster $KAFKA_CLUSTER_ID \
                     --environment $ENV_ID \
                     --api-key $CONSUMER_KEY \
                     --api-secret \"$CONSUMER_SECRET\""

case $STOCK_GROUP in
  under_100 | buy | sell)
    CMD="confluent kafka topic consume $CONSUMER_OPTS"
    echo $CMD
    $CMD
  ;;

*)
  echo $USAGE >&2
  ;;
esac
