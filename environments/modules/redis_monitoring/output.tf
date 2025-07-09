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

# output "alert_policy_ids" {
#   description = "Map of all alert policy IDs"
#   value = {
#     high_memory_usage = google_monitoring_alert_policy.high_memory_usage.id
#     evictions         = google_monitoring_alert_policy.evictions.id
#     uptime_drop       = google_monitoring_alert_policy.uptime_drop.id
#     oom_error_alert   = google_monitoring_alert_policy.oom_error_alert.id
#     #failover_alert    = google_monitoring_alert_policy.failover_alert.id
#   }
# }

# output "alert_policy_names" {
#   description = "Map of all alert policy display names"
#   value = {
#     high_memory_usage = google_monitoring_alert_policy.high_memory_usage.display_name
#     evictions         = google_monitoring_alert_policy.evictions.display_name
#     uptime_drop       = google_monitoring_alert_policy.uptime_drop.display_name
#     oom_error_alert   = google_monitoring_alert_policy.oom_error_alert.display_name
#     #failover_alert    = google_monitoring_alert_policy.failover_alert.display_name
#   }
# }
