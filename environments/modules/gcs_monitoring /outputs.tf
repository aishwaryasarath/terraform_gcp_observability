
output "gcs_error_alert_policy_ids" {
  description = "Map of GCS alert policy IDs per error code"
  value = {
    for k, policy in google_monitoring_alert_policy.gcs_error_alerts :
    k => policy.id
  }
}

output "gcs_error_alert_policy_names" {
  description = "Map of GCS alert policy display names per error code"
  value = {
    for k, policy in google_monitoring_alert_policy.gcs_error_alerts :
    k => policy.display_name
  }
}


output "gcs_error_log_metric_names" {
  description = "Names of GCS log-based error metrics"
  value       = [for k in keys(google_logging_metric.gcs_error_metrics) : google_logging_metric.gcs_error_metrics[k].name]
}

output "gcs_error_log_metric_display_names" {
  description = "Display names of GCS log-based error metrics"
  value       = [for k in keys(google_logging_metric.gcs_error_metrics) : google_logging_metric.gcs_error_metrics[k].metric_descriptor.0.display_name]
}

# output "notification_channel_id" {
#   description = "ID of the email notification channel"
#   value       = google_monitoring_notification_channel.email.id
# }
