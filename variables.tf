variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "output_topic" {
  description = "Output topic name of connector"
  type = string
  sensitive = false
}

variable "target_cloud" {
  description = "Cloud to be hosted (GCP)"
  type = string
  default = "GCP"
  sensitive = false
}

variable "target_region" {
  description = "Hosting region (us-central1)"
  type = string
  default = "us-central1"
  sensitive = false
}

variable schema_package {
  description = "governance package (ESSENTIALS)"
  default = "ESSENTIALS"
  type = string
  sensitive = false
}