# output "dashboard_id" {
#   description = "ID of the Redis Monitoring dashboard"
#   value       = google_monitoring_dashboard.redis_dashboard.id
# }

# output "dashboard_display_name" {
#   description = "Display name of the Redis Monitoring dashboard"
#   value       = "Redis Monitoring Dashboard"
# }

output "oom_logging_metric_name" {
  description = "Logging metric for Redis OOM errors"
  value       = google_logging_metric.oom_errors.name
}

output "alert_policy_ids" {
  description = "Map of all alert policy IDs"
  value = {
    redis_memory_utilization = google_monitoring_alert_policy.redis_memory_utilization.id
    redis_cpu_utilization    = google_monitoring_alert_policy.redis_cpu_utilization.id
    redis_failover           = google_monitoring_alert_policy.redis_failover.id
    oom_error_alert          = google_monitoring_alert_policy.oom_error_alert.id
    test_eviction2           = google_monitoring_alert_policy.test_eviction2.id

  }
}

output "alert_policy_names" {
  description = "Map of all alert policy display names"
  value = {
    redis_memory_utilization = google_monitoring_alert_policy.redis_memory_utilization.name
    redis_cpu_utilization    = google_monitoring_alert_policy.redis_cpu_utilization.name
    redis_failover           = google_monitoring_alert_policy.redis_failover.name
    oom_error_alert          = google_monitoring_alert_policy.oom_error_alert.name
    test_eviction2           = google_monitoring_alert_policy.test_eviction2.name

  }
}
