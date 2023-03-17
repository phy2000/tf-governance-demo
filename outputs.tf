output "resource-ids" {
  value = <<-EOT
  Environment ID:   ${confluent_environment.staging.id}
  Kafka Cluster ID: ${confluent_kafka_cluster.demo.id}
  Kafka topic name: ${confluent_kafka_topic.stocks.topic_name}



#
  Service Accounts and their Kafka API Keys (API Keys inherit the permissions granted to the owner):
  ${confluent_service_account.app-manager.display_name}:                     ${confluent_service_account.app-manager.id}
  ${confluent_service_account.app-manager.display_name}'s Kafka API Key:     "${confluent_api_key.app-manager-kafka-api-key.id}"
  ${confluent_service_account.app-manager.display_name}'s Kafka API Secret:  "${confluent_api_key.app-manager-kafka-api-key.secret}"

  ${confluent_service_account.app-producer.display_name}:                    ${confluent_service_account.app-producer.id}
  ${confluent_service_account.app-producer.display_name}'s Kafka API Key:    "${confluent_api_key.app-producer-kafka-api-key.id}"
  ${confluent_service_account.app-producer.display_name}'s Kafka API Secret: "${confluent_api_key.app-producer-kafka-api-key.secret}"

  ${confluent_service_account.app-consumer.display_name}:                    ${confluent_service_account.app-consumer.id}
  ${confluent_service_account.app-consumer.display_name}'s Kafka API Key:    "${confluent_api_key.app-consumer-kafka-api-key.id}"
  ${confluent_service_account.app-consumer.display_name}'s Kafka API Secret: "${confluent_api_key.app-consumer-kafka-api-key.secret}"

  In order to use the Confluent CLI v2 to produce and consume messages from topic '${confluent_kafka_topic.stocks.topic_name}' using Kafka API Keys
  of ${confluent_service_account.app-producer.display_name} and ${confluent_service_account.app-consumer.display_name} service accounts
  run the following commands:

  # 1. Log in to Confluent Cloud
  $ confluent login

  # 2. Produce key-value records to topic '${confluent_kafka_topic.stocks.topic_name}' by using ${confluent_service_account.app-producer.display_name}'s Kafka API Key
  $ confluent kafka topic produce ${confluent_kafka_topic.stocks.topic_name} --environment ${confluent_environment.staging.id} --cluster ${confluent_kafka_cluster.demo.id} --api-key "${confluent_api_key.app-producer-kafka-api-key.id}" --api-secret "${confluent_api_key.app-producer-kafka-api-key.secret}"
  # Enter a few records and then press 'Ctrl-C' when you're done.
  # Sample records:
  # {"number":1,"date":18500,"shipping_address":"899 W Evelyn Ave, Mountain View, CA 94041, USA","cost":15.00}
  # {"number":2,"date":18501,"shipping_address":"1 Bedford St, London WC2E 9HG, United Kingdom","cost":5.00}
  # {"number":3,"date":18502,"shipping_address":"3307 Northland Dr Suite 400, Austin, TX 78731, USA","cost":10.00}

  # 3. Consume records from topic '${confluent_kafka_topic.stocks.topic_name}' by using ${confluent_service_account.app-consumer.display_name}'s Kafka API Key
  $ confluent kafka topic consume ${confluent_kafka_topic.stocks.topic_name} --from-beginning --environment ${confluent_environment.staging.id} --cluster ${confluent_kafka_cluster.demo.id} --api-key "${confluent_api_key.app-consumer-kafka-api-key.id}" --api-secret "${confluent_api_key.app-consumer-kafka-api-key.secret}"
  # When you are done, press 'Ctrl-C'.

# ksqlDB Outputs
  ksqlDB Cluster ID:                    ${confluent_ksql_cluster.main.id}
  ksqlDB Cluster API Endpoint:          ${confluent_ksql_cluster.main.rest_endpoint}
  KSQL Service Account ID:              ${confluent_service_account.app-ksql.id}
  KSQL API Key:                         ${confluent_api_key.app-ksqldb-api-key.id}
  KSQL API Secret:                      ${confluent_api_key.app-ksqldb-api-key.secret}



  EOT

  sensitive = true
}

output "ksql-properties" {
  value = <<-EOT
ksql.server.url=${confluent_ksql_cluster.main.rest_endpoint}
# Migrations metadata configs:
# ksql.migrations.stream.name=MIGRATION_EVENTS
# ksql.migrations.table.name=MIGRATION_SCHEMA_VERSIONS
# ksql.migrations.stream.topic.name=ksql-service-idksql_MIGRATION_EVENTS
# ksql.migrations.table.topic.name=ksql-service-idksql_MIGRATION_SCHEMA_VERSIONS  ksql.migrations.topic.replicas=3
# Migrations metadata configs:
# ksql.migrations.stream.name=MIGRATION_EVENTS
# ksql.migrations.table.name=MIGRATION_SCHEMA_VERSIONS
# ksql.migrations.stream.topic.name=ksql-service-idksql_MIGRATION_EVENTS
# ksql.migrations.table.topic.name=ksql-service-idksql_MIGRATION_SCHEMA_VERSIONS
ssl.alpn=true
# ksqlDB server authentication configs:
ksql.auth.basic.username=${confluent_api_key.app-ksqldb-api-key.id}
ksql.auth.basic.password=${confluent_api_key.app-ksqldb-api-key.secret}

EOT

  sensitive = true
}