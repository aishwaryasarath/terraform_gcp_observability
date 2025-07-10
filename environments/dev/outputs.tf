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
