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

variable "cluster_cloud" {
  description = "Cloud to be hosted (GCP)"
  type = string
  default = "GCP"
  sensitive = false
}

variable "cluster_region" {
  description = "Hosting region (us-central1)"
  type = string
  default = "us-central1"
  sensitive = false
}

# Required:
variable "schema_package" {
  description = "governance package (Match the imported SR package or upgrade to ADVANCED)"
  type = string
  sensitive = false
}

# Required:
variable "schema_region" {
  description = "Region for schema registry"
  type = string
  sensitive = false
}

# Required:
variable "schema_cloud" {
  description = "Which cloud for schema registry"
  type = string
  sensitive = false
}

variable "env_display_name" {
  description = "Match the display name of the imported environment"
  type = string
  sensitive = false
}
