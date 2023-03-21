# Contents of ksql-governance-demo/ksql-migrations.properties
output "ksql-properties" {
  value=<<-EOT
ksql.server.url=${confluent_ksql_cluster.main.rest_endpoint}
ksql.migrations.topic.replicas=3
ssl.alpn=true
ksql.auth.basic.username=${confluent_api_key.app-ksqldb-api-key.id}
ksql.auth.basic.password=${confluent_api_key.app-ksqldb-api-key.secret}

EOT

  sensitive=true
}

# Contents of scripts/env.vars
output "tf-env" {
  value=<<-EOT
# Environment variables
# Source this file
set -a
ENV_ID="${confluent_environment.staging.id}"
KAFKA_CLUSTER_ID="${confluent_kafka_cluster.demo.id}"

KSQL_CLUSTER_ID="${confluent_ksql_cluster.main.id}"
KSQL_ENDPT="${confluent_ksql_cluster.main.rest_endpoint}"
KSQL_ACCT_ID="${confluent_service_account.app-ksql.id}"
KSQL_KEY="${confluent_api_key.app-ksqldb-api-key.id}"
KSQL_SECRET="${confluent_api_key.app-ksqldb-api-key.secret}"

SR_CLUSTER_ID="${confluent_schema_registry_cluster.demo.id}"
SR_ENDPT="${confluent_schema_registry_cluster.demo.rest_endpoint}"
SR_ACCT_ID="${confluent_service_account.env-manager.id}"
SR_KEY="${confluent_api_key.env-manager-schema-registry-api-key.id}"
SR_SECRET="${confluent_api_key.env-manager-schema-registry-api-key.secret}"

PRODUCER_ACCT_ID="${confluent_service_account.app-producer.id}"
PRODUCER_KEY="${confluent_api_key.app-producer-kafka-api-key.id}"
PRODUCER_SECRET="${confluent_api_key.app-producer-kafka-api-key.secret}"

CONSUMER_ACCT_ID="${confluent_service_account.app-consumer.id}"
CONSUMER_KEY="${confluent_api_key.app-consumer-kafka-api-key.id}"
CONSUMER_SECRET="${confluent_api_key.app-consumer-kafka-api-key.secret}"

ADMIN_ACCT_ID="${confluent_service_account.app-manager.id}"
ADMIN_KEY="${confluent_api_key.app-manager-kafka-api-key.id}"
ADMIN_SECRET="${confluent_api_key.app-manager-kafka-api-key.secret}"

CONNECTOR_ACCT_ID="${confluent_service_account.app-connector.id}"
CONNECTOR_KEY="${confluent_api_key.app-connector-kafka-api-key.id}"
CONNECTOR_SECRET="${confluent_api_key.app-connector-kafka-api-key.secret}"
DATAGEN_CONNECTOR_ID="${confluent_connector.source.id}"

set +a

EOT

  sensitive=true
}

# Contents of jmx-monitoring-stacks/ccloud-prometheus-grafana/utils/env_variables.env
output "jmx_monitor_env" {
  value=<<-EOT
export CCLOUD_API_KEY="${var.confluent_cloud_api_key}"
export CCLOUD_API_SECRET="${var.confluent_cloud_api_secret}"
export CCLOUD_KAFKA_LKC_IDS="${confluent_kafka_cluster.demo.id}"
export CCLOUD_CONNECT_LCC_IDS="${confluent_connector.source.id}"
export CCLOUD_KSQL_LKSQLC_IDS="${confluent_ksql_cluster.main.id}"
export CCLOUD_SR_LSRC_IDS="${confluent_schema_registry_cluster.demo.id}"
EOT

  sensitive=true
}