variable "name" {
  type        = string
  description = "Redis instance name"
}

variable "region" {
  type        = string
  description = "GCP region for Redis"
}

variable "tier" {
  type        = string
  default     = "STANDARD_HA"
  description = "Redis tier: BASIC or STANDARD_HA"
}

variable "memory_size_gb" {
  type        = number
  description = "Memory size in GB"
}

variable "display_name" {
  type        = string
  default     = null
  description = "Optional display name"
}
