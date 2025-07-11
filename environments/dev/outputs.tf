output "instance_name" {
  value = module.instance.instance_name
}

output "bucket1_url" {
  value = module.bucket1.bucket_url
}

output "bucket2_url" {
  value = module.bucket2.bucket_url
}
# root outputs.tf
# output "redis_dashboard_id" {
#   value = module.redis_monitoring.dashboard_id
# }

output "redis_alert_policy_ids" {
  value = module.redis_monitoring.alert_policy_ids
}

output "redis_alert_policy_names" {
  value = module.redis_monitoring.alert_policy_names
}

output "redis_oom_logging_metric" {
  value = module.redis_monitoring.oom_logging_metric_name
}


output "gcs_alert_policy_names" {
  description = "Map of GCS alert policy display names per error code"
  value       = module.gcs_monitoring.gcs_error_alert_policy_names
}

output "gcs_alert_policy_ids" {
  description = "Map of GCS alert policy IDs per error code"
  value       = module.gcs_monitoring.gcs_error_alert_policy_ids
}

output "gcs_log_metric_names" {
  description = "List of GCS error log-based metric names"
  value       = module.gcs_monitoring.gcs_error_log_metric_names
}

output "gcs_log_metric_display_names" {
  description = "List of GCS error log-based metric display names"
  value       = module.gcs_monitoring.gcs_error_log_metric_display_names
}
