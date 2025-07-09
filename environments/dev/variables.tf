variable "project" {}
variable "region" {}
variable "zone" {}
variable "memory_threshold_bytes" {
  type        = number
  description = "Memory usage threshold in bytes"

}
variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}


variable "redis_instance_id" {
  description = "ID of the Redis instance to monitor"
  type        = string
}
