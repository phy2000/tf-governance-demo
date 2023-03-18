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

resource "confluent_environment" "staging" {
  display_name = "Staging"
}

# Stream Governance and Kafka clusters can be in different regions as well as different cloud providers,
# but you should to place both in the same cloud and region to restrict the fault isolation boundary.
data "confluent_schema_registry_region" "demo" {
  cloud        = "GCP"
  region       = "us-central1"
  package = var.schema_package
}

resource "confluent_schema_registry_cluster" "demo" {
  package = data.confluent_schema_registry_region.demo.package

  environment {
    id = confluent_environment.staging.id
  }

  region {
    # See https://docs.confluent.io/cloud/current/stream-governance/packages.html#stream-governance-regions
    id = data.confluent_schema_registry_region.demo.id
  }
}

# Update the config to use a cloud provider and region of your choice.
# https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_kafka_cluster
resource "confluent_kafka_cluster" "demo" {
  display_name = "inventory"
  availability = "SINGLE_ZONE"
  cloud        = "GCP"
  region       = "us-central1"
  standard {}
  environment {
    id = confluent_environment.staging.id
  }
}

resource "confluent_kafka_topic" "stocks" {
  kafka_cluster {
    id = confluent_kafka_cluster.demo.id
  }
  topic_name    = var.output_topic
  rest_endpoint = confluent_kafka_cluster.demo.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}
