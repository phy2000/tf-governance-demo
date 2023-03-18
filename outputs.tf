output "resource-ids" {
  value=<<-EOT
  Environment ID:   ${confluent_environment.staging.id}
  Kafka Cluster ID: ${confluent_kafka_cluster.demo.id}
  Kafka topic name: ${confluent_kafka_topic.stocks.topic_name}

  Service Accounts and their Kafka API Keys (API Keys inherit the permissions granted to the owner):
  ${confluent_service_account.app-manager.display_name}:                     "${confluent_service_account.app-manager.id}"
  ${confluent_service_account.app-manager.display_name}'s Kafka API Key:     "${confluent_api_key.app-manager-kafka-api-key.id}"
  ${confluent_service_account.app-manager.display_name}'s Kafka API Secret:  "${confluent_api_key.app-manager-kafka-api-key.secret}"

  ${confluent_service_account.app-producer.display_name}:                    ${confluent_service_account.app-producer.id}
  ${confluent_service_account.app-producer.display_name}'s Kafka API Key:    "${confluent_api_key.app-producer-kafka-api-key.id}"
  ${confluent_service_account.app-producer.display_name}'s Kafka API Secret: "${confluent_api_key.app-producer-kafka-api-key.secret}"

  ${confluent_service_account.app-consumer.display_name}:                    ${confluent_service_account.app-consumer.id}
  ${confluent_service_account.app-consumer.display_name}'s Kafka API Key:    "${confluent_api_key.app-consumer-kafka-api-key.id}"
  ${confluent_service_account.app-consumer.display_name}'s Kafka API Secret: "${confluent_api_key.app-consumer-kafka-api-key.secret}"


# ksqlDB Outputs
  ksqlDB Cluster ID:                    ${confluent_ksql_cluster.main.id}
  ksqlDB Cluster API Endpoint:          ${confluent_ksql_cluster.main.rest_endpoint}
  KSQL Service Account ID:              ${confluent_service_account.app-ksql.id}
  KSQL API Key:                         ${confluent_api_key.app-ksqldb-api-key.id}
  KSQL API Secret:                      ${confluent_api_key.app-ksqldb-api-key.secret}



  EOT

  sensitive=true
}

output "ksql-properties" {
  value=<<-EOT
ksql.server.url=${confluent_ksql_cluster.main.rest_endpoint}
# Migrations metadata configs:
# ksql.migrations.stream.name=MIGRATION_EVENTS
# ksql.migrations.table.name=MIGRATION_SCHEMA_VERSIONS
# ksql.migrations.stream.topic.name=ksql-service-idksql_MIGRATION_EVENTS
# ksql.migrations.table.topic.name=ksql-service-idksql_MIGRATION_SCHEMA_VERSIONS
ksql.migrations.topic.replicas=3

# TLS configs:
# ssl.truststore.location=
# ssl.truststore.password=
# ssl.keystore.location=
# ssl.keystore.password=
# ssl.key.password=
# ssl.key.alias=
ssl.alpn=true
# ssl.verify.host=true

# ksqlDB server authentication configs:
ksql.auth.basic.username=${confluent_api_key.app-ksqldb-api-key.id}
ksql.auth.basic.password=${confluent_api_key.app-ksqldb-api-key.secret}

EOT

  sensitive=true
}

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

set +a

EOT

  sensitive=true
}