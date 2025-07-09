output "instance_id" {
  value       = google_redis_instance.this.name
  description = "Redis instance ID"
}
