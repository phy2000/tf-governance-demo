######## REQUIRED ########
variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "schema_id" {
  description = "ID of environment's schema registry cluster. EX: lsrc-xxxx"
  type        = string
  sensitive   = false
}

variable "env_id" {
  description = "ID of environment. EX: env-xxxx"
  type        = string
  sensitive   = false
}

###### OPTIONAL ########
variable "source_topic" {
  description = "Output topic name of connector"
  type        = string
  default     = "stocks"
  sensitive   = false
}

variable "cluster_cloud" {
  description = "Cloud to be hosted (GCP)"
  type        = string
  default     = "GCP"
  sensitive   = false
}

variable "cluster_region" {
  description = "Hosting region (us-central1)"
  type        = string
  default     = "us-central1"
  sensitive   = false
}
variable "cluster_name" {
  description = "Name for the new kafka cluster"
  type        = string
  default     = "Stocks"
  sensitive   = false
}
