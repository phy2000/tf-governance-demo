// ksqlDB service account
resource "confluent_service_account" "app-ksql" {
  display_name = "app-ksql"
  description  = "Service account for ksqlDB cluster"
}

resource "confluent_role_binding" "app-ksql-all-topic" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${confluent_kafka_cluster.demo.rbac_crn}/kafka=${confluent_kafka_cluster.demo.id}/topic=*"
}

resource "confluent_role_binding" "app-ksql-all-group" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${confluent_kafka_cluster.demo.rbac_crn}/kafka=${confluent_kafka_cluster.demo.id}/group=*"
}

resource "confluent_role_binding" "app-ksql-all-transactions" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${confluent_kafka_cluster.demo.rbac_crn}/kafka=${confluent_kafka_cluster.demo.id}/transactional-id=*"
}

# ResourceOwner roles above are for KSQL service account to read/write data from/to kafka,
# this role instead is needed for giving access to the Ksql cluster.
resource "confluent_role_binding" "app-ksql-ksql-admin" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "KsqlAdmin"
  crn_pattern = confluent_ksql_cluster.main.resource_name
}

resource "confluent_role_binding" "app-ksql-schema-registry-resource-owner" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "ResourceOwner"
  crn_pattern = format("%s/%s", confluent_schema_registry_cluster.demo.resource_name, "subject=*")
}

resource "confluent_ksql_cluster" "main" {
  display_name = "ksql_cluster_0"
  csu = 1
  kafka_cluster {
    id = confluent_kafka_cluster.demo.id
  }
  credential_identity {
    id = confluent_service_account.app-ksql.id
  }
  environment {
    id = confluent_environment.staging.id
  }
  depends_on = [
    confluent_role_binding.app-ksql-schema-registry-resource-owner,
    confluent_schema_registry_cluster.demo
  ]
}

resource "confluent_api_key" "app-ksqldb-api-key" {
  display_name = "app-ksqldb-api-key"
  description  = "KsqlDB API Key that is owned by 'app-ksql' service account"
  owner {
    id          = confluent_service_account.app-ksql.id
    api_version = confluent_service_account.app-ksql.api_version
    kind        = confluent_service_account.app-ksql.kind
  }

  managed_resource {
    id          = confluent_ksql_cluster.main.id
    api_version = confluent_ksql_cluster.main.api_version
    kind        = confluent_ksql_cluster.main.kind

    environment {
      id = confluent_environment.staging.id
    }
  }
}