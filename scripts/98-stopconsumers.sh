#!/bin/bash

NOW=$(date '+%Y-%m-%d:%H%M%S')

for _TYPE in under_100 buy sell; do
  topic=stocks_$_TYPE
  echo Killing consumer for $topic
  pkill -l -f "confluent kafka topic consume $topic"
done