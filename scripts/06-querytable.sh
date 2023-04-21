#!/bin/bash
SCRIPTDIR=$(dirname $0)
source $SCRIPTDIR/env.vars
BASEDIR=$SCRIPTDIR/..
LOGDIR=$BASEDIR/logs
PIDS=$SCRIPTDIR/run

TOPIC_NAME=stocks_table_topic
confluent login --prompt

confluent kafka topic create \
    --if-not-exists \
    --partitions 1 \
    --cluster $KAFKA_CLUSTER_ID \
    $TOPIC_NAME

curl --http1.1 \
     --user "${KSQL_KEY}:${KSQL_SECRET}" \
     -X "POST" "{$KSQL_ENDPT}/query" \
     -H "Accept: application/vnd.ksql.v1+json" \
     -H "Content-Type: application/json" \
     -d $'{
          "ksql": "select * from queryable_stocks_table;",
          "streamsProperties": {}
        }' \
    | jq -c '.[]' \
    | confluent kafka topic produce \
          --value-format string \
          --schema-registry-endpoint $SR_ENDPT \
          --schema-registry-api-key "${SR_KEY}" \
          --schema-registry-api-secret "${SR_SECRET}" \
          --api-key "${PRODUCER_KEY}" \
          --api-secret "${PRODUCER_SECRET}" \
          --cluster "${KAFKA_CLUSTER_ID}" \
          $TOPIC_NAME
exit
#  jq -c '.[0].header.schema ,
# | jq -c '.[0].header.schema,.[].row.columns' | grep -v '^null$'

