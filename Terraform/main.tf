terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.23.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}
data "confluent_environment" "demo-env" {
  id = var.env_id
}

data "confluent_schema_registry_cluster" "demo-schema" {
  id = var.schema_id
  environment {
    id = var.env_id
  }
}

# Update the config to use a cloud provider and region of your choice.

resource "confluent_kafka_cluster" "demo-cluster" {
  display_name = var.cluster_name
  cloud        = var.cluster_cloud
  region       = var.cluster_region
  availability = "SINGLE_ZONE"
  standard {}
  environment {
    id = data.confluent_environment.demo-env.id
  }
}

resource "confluent_kafka_topic" "stocks" {
  kafka_cluster {
    id = confluent_kafka_cluster.demo-cluster.id
  }
  topic_name    = var.source_topic
  rest_endpoint = confluent_kafka_cluster.demo-cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}
