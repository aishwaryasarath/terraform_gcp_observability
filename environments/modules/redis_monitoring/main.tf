
# --------------custom --------------
resource "google_logging_metric" "oom_errors" {
  name   = "oom_errors"
  filter = "resource.type=\"redis_instance\" AND textPayload:\"OOM command not allowed\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Redis OOM Errors"
  }
}




resource "google_monitoring_alert_policy" "test_eviction2" {
  display_name = "test-eviction"
  combiner     = "OR"
  enabled      = true

  alert_strategy {
    auto_close           = "21600s"
    notification_prompts = ["OPENED", "CLOSED"]
  }

  notification_channels = [
    "projects/intense-reason-458522-h4/notificationChannels/16837620454532209889"
  ]
  user_labels = {
    project_id    = var.project_id
    context       = "redis"
    instance_id   = var.redis_instance_id
    resource_type = "redis_instance"
    region        = var.region
  }
  conditions {
    display_name = "Cloud Memorystore Redis Instance - Evicted Keys"

    condition_threshold {
      filter          = "resource.type = \"redis_instance\" AND metric.type = \"redis.googleapis.com/stats/evicted_keys\""
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      threshold_value = 1

      trigger {
        count = 1
      }

      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
}

resource "google_monitoring_alert_policy" "oom_error_alert" {
  display_name = "${var.environment} - Redis OOM Error"
  combiner     = "OR"
  conditions {
    display_name = "OOM Error > 0"
    condition_threshold {
      filter          = "resource.type=\"redis_instance\" AND metric.type=\"logging.googleapis.com/user/oom_errors\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      duration        = "60s"
      trigger {
        count = 1
      }
    }
  }
  user_labels = {
    project_id    = var.project_id
    context       = "redis"
    instance_id   = var.redis_instance_id
    resource_type = "redis_instance"
    region        = var.region
  }
  notification_channels = [google_monitoring_notification_channel.email.id]
}


resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Alerts"
  type         = "email"
  labels = {
    email_address = "aishwaryasarath2025@gmail.com"
  }
}



# --------------from gcp --------------
resource "google_monitoring_alert_policy" "redis_memory_utilization" {
  display_name = "Cloud Redis - System Memory Utilization for dev-redis-instance(us-central1)"

  documentation {
    content   = "This alert fires if the system memory utilization is above the set threshold. The utilization is measured on a scale of 0 to 1."
    mime_type = "text/markdown"
  }

  combiner = "OR"
  enabled  = true

  user_labels = {
    instance_id   = "dev-redis-instance"
    region        = "us-central1"
    resource_type = "redis_instance"
    project_id    = "intense-reason-458522-h4"
    context       = "redis"
  }

  conditions {
    display_name = "Cloud Memorystore Redis Instance - System Memory Usage Ratio"

    condition_threshold {
      filter = "resource.type = \"redis_instance\" AND resource.labels.instance_id = \"projects/${var.project_id}/locations/us-central1/instances/${var.redis_instance_id}\" AND metric.type = \"redis.googleapis.com/stats/memory/system_memory_usage_ratio\""

      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8

      trigger {
        count = 1
      }

      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  alert_strategy {
    auto_close = "604800s"
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
}

resource "google_monitoring_alert_policy" "redis_cpu_utilization" {
  display_name = "Cloud Redis - Redis Engine CPU utilization for dev-redis-instance(us-central1)"

  documentation {
    content   = "This alert fires if the Redis Engine CPU Utilization goes above the set threshold. The utilization is measured on a scale of 0 to 1. "
    mime_type = "text/markdown"
  }

  combiner = "OR"
  enabled  = true

  user_labels = {
    instance_id   = "dev-redis-instance"
    region        = "us-central1"
    resource_type = "redis_instance"
    project_id    = "intense-reason-458522-h4"
    context       = "redis"
  }

  conditions {
    display_name = "Cloud Memorystore Redis Instance - Redis Engine CPU utilization"

    condition_threshold {
      filter = "resource.type = \"redis_instance\" AND resource.labels.instance_id = \"projects/${var.project_id}/locations/us-central1/instances/${var.redis_instance_id}\" AND metric.type = \"redis.googleapis.com/stats/cpu_utilization_main_thread\""


      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.9

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields      = ["resource.label.instance_id", "resource.label.node_id"]
      }
    }
  }

  alert_strategy {
    auto_close = "604800s"
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
}
resource "google_monitoring_alert_policy" "redis_failover" {
  display_name = "Cloud Redis - Standard Instance Failover for dev-redis-instance(us-central1)"

  documentation {
    content   = "This alert fires if failover occurs for a standard tier instance. To ensure that alerts always fire, we recommend keeping the threshold value to 0"
    mime_type = "text/markdown"
  }

  combiner = "OR"
  enabled  = true

  user_labels = {
    project_id    = var.project_id
    context       = "redis"
    instance_id   = var.redis_instance_id
    resource_type = "redis_instance"
    region        = var.region
  }

  conditions {
    display_name = "Cloud Memorystore Redis Instance - Failover"

    condition_threshold {
      filter          = "resource.type = \"redis_instance\" AND resource.labels.instance_id = \"projects/${var.project_id}/locations/${var.region}/instances/${var.redis_instance_id}\" AND metric.type = \"redis.googleapis.com/replication/role\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_COUNT"
      }

      trigger {
        count = 1
      }
    }
  }

  alert_strategy {
    auto_close = "604800s"
  }

  notification_channels = [
    "projects/${var.project_id}/notificationChannels/16837620454532209889"
  ]
}

# resource "google_monitoring_alert_policy" "redis_failover" {
#   display_name = "Cloud Redis - Standard Instance Failover for dev-redis-instance(us-central1)"

#   documentation {
#     content   = "This alert fires if failover occurs for a standard tier instance. To ensure that alerts always fire, we recommend keeping the threshold value to 0"
#     mime_type = "text/markdown"
#   }

#   combiner = "OR"
#   enabled  = true

#   user_labels = {
#     project_id    = var.project_id
#     context       = "redis"
#     instance_id   = var.redis_instance_id
#     resource_type = "redis_instance"
#     region        = var.region
#   }

#   conditions {
#     display_name = "Cloud Memorystore Redis Instance - Node Role"

#     condition_threshold {
#       filter = "resource.type = \"redis_instance\" AND resource.labels.instance_id = \"projects/${var.project_id}/locations/us-central1/instances/${var.redis_instance_id}\" AND metric.type = \"redis.googleapis.com/replication/role\""


#       duration        = "0s"
#       comparison      = "COMPARISON_GT"
#       threshold_value = 0

#       trigger {
#         count = 1
#       }

#       aggregations {
#         alignment_period   = "300s"
#         per_series_aligner = "ALIGN_STDDEV"
#       }
#     }
#   }

#   alert_strategy {
#     auto_close = "604800s"
#   }

#   notification_channels = [google_monitoring_notification_channel.email.id]
# }

# resource "google_logging_metric" "redis_connection_lost" {
#   name        = "redis_replica_connection_lost"
#   description = "Counts how often Redis replica loses connection to the master"

#   filter = <<EOT
# resource.type="redis_instance"
# jsonPayload.message:"Connection with master lost"
# EOT

#   metric_descriptor {
#     metric_kind = "DELTA"
#     value_type  = "INT64"
#     unit        = "1"
#   }

#   label_extractors = {}
# }
# resource "google_monitoring_alert_policy" "redis_connection_lost_alert" {
#   display_name = "${var.environment} - Redis Replica Lost Master Connection"

#   combiner = "OR"

#   conditions {
#     display_name = "Replica lost master connection"
#     condition_threshold {
#       filter = <<EOT
# resource.type="redis_instance"
# metric.type="logging.googleapis.com/user/redis_replica_connection_lost"
# EOT

#       comparison      = "COMPARISON_GT"
#       threshold_value = 0
#       duration        = "0s"

#       aggregations {
#         alignment_period   = "60s"
#         per_series_aligner = "ALIGN_SUM"
#       }

#       trigger {
#         count = 1
#       }
#     }
#   }

#   documentation {
#     content   = "Redis replica lost connection to the master. Investigate network issues or failover events."
#     mime_type = "text/markdown"
#   }

#   notification_channels = [google_monitoring_notification_channel.email.id]
# }


# resource "google_monitoring_dashboard" "redis_dashboard" {
#   dashboard_json = jsonencode({
#     displayName = "Redis Monitoring Dashboard"
#     gridLayout = {
#       columns = 2
#       widgets = [
#         {
#           title = "Memory Usage"
#           xyChart = {
#             dataSets = [{
#               timeSeriesQuery = {
#                 timeSeriesFilter = {
#                   filter = "metric.type=\"redis.googleapis.com/stats/memory/used_bytes\" resource.type=\"redis_instance\" resource.label.\"instance_id\"=\"${var.redis_instance_id}\""
#                   aggregation = {
#                     alignmentPeriod  = "60s"
#                     perSeriesAligner = "ALIGN_MEAN"
#                   }
#                 }
#               }
#               plotType = "LINE"
#             }]
#           }
#         },
#         {
#           title = "CPU Utilization"
#           xyChart = {
#             dataSets = [{
#               timeSeriesQuery = {
#                 timeSeriesFilter = {
#                   filter = "metric.type=\"redis.googleapis.com/stats/cpu/utilization\" resource.type=\"redis_instance\" resource.label.\"instance_id\"=\"${var.redis_instance_id}\""
#                   aggregation = {
#                     alignmentPeriod  = "60s"
#                     perSeriesAligner = "ALIGN_MEAN"
#                   }
#                 }
#               }
#               plotType = "LINE"
#             }]
#           }
#         },
#         {
#           title = "Client Connections"
#           xyChart = {
#             dataSets = [{
#               timeSeriesQuery = {
#                 timeSeriesFilter = {
#                   filter = "metric.type=\"redis.googleapis.com/stats/connected_clients\" resource.type=\"redis_instance\" resource.label.\"instance_id\"=\"${var.redis_instance_id}\""
#                   aggregation = {
#                     alignmentPeriod  = "60s"
#                     perSeriesAligner = "ALIGN_MEAN"
#                   }
#                 }
#               }
#               plotType = "LINE"
#             }]
#           }
#         },
#         {
#           title = "Uptime"
#           xyChart = {
#             dataSets = [{
#               timeSeriesQuery = {
#                 timeSeriesFilter = {
#                   filter = "metric.type=\"redis.googleapis.com/stats/uptime\" resource.type=\"redis_instance\" resource.label.\"instance_id\"=\"${var.redis_instance_id}\""
#                   aggregation = {
#                     alignmentPeriod  = "60s"
#                     perSeriesAligner = "ALIGN_MEAN"
#                   }
#                 }
#               }
#               plotType = "LINE"
#             }]
#           }
#         },
#         {
#           title = "Failover Count"
#           xyChart = {
#             dataSets = [{
#               timeSeriesQuery = {
#                 timeSeriesFilter = {
#                   filter = "metric.type=\"redis.googleapis.com/stats/failover_count\" resource.type=\"redis_instance\" resource.label.\"instance_id\"=\"${var.redis_instance_id}\""
#                   aggregation = {
#                     alignmentPeriod  = "60s"
#                     perSeriesAligner = "ALIGN_DELTA"
#                   }
#                 }
#               }
#               plotType = "LINE"
#             }]
#           }
#         }
#       ]
#     }
#   })
# }

# resource "google_logging_metric" "redis_failover_metric" {
#   name   = "redis_failover_log_metric"
#   filter = "resource.type=\"redis_instance\" AND protoPayload.methodName=\"google.cloud.redis.v1.CloudRedis.FailoverInstance\""
#   metric_descriptor {
#     metric_kind  = "DELTA"
#     value_type   = "INT64"
#     unit         = "1"
#     display_name = "Redis Failover Count"
#   }
# }

# resource "google_monitoring_alert_policy" "failover_alert" {
#   display_name = "${var.environment} - Redis Failover detected"
#   combiner     = "OR"
#   conditions {
#     display_name = "Failover log event occurred"
#     condition_threshold {
#       filter          = "resource.type=\"redis_instance\" AND metric.type=\"logging.googleapis.com/user/redis_failover_log_metric\""
#       comparison      = "COMPARISON_GT"
#       threshold_value = 0
#       duration        = "0s"
#       aggregations {
#         alignment_period   = "60s"
#         per_series_aligner = "ALIGN_SUM"
#       }
#     }
#   }
#   documentation {
#     content   = "A failover event has been detected in the Redis instance. Please check the logs for more details."
#     mime_type = "text/markdown"
#   }
#   notification_channels = [google_monitoring_notification_channel.email.id]
# }

# resource "google_monitoring_alert_policy" "uptime_drop" {
#   display_name = "${var.environment} - Redis Uptime = 0"
#   combiner     = "OR"
#   conditions {
#     display_name = "Uptime = 0"
#     condition_threshold {
#       filter          = "metric.type=\"redis.googleapis.com/server/uptime\" resource.type=\"redis_instance\" resource.label.\"instance_id\"=\"${var.redis_instance_id}\""
#       comparison      = "COMPARISON_LT"
#       threshold_value = 10
#       duration        = "60s"
#       trigger {
#         count = 1
#       }
#     }
#   }
#   notification_channels = [google_monitoring_notification_channel.email.id]
# }

# resource "google_monitoring_alert_policy" "high_memory_usage" {
#   display_name = "${var.environment} - Redis High Memory Usage"
#   combiner     = "OR"
#   conditions {
#     display_name = "Memory > ${var.memory_threshold_bytes} bytes"
#     condition_threshold {
#       filter          = "metric.type=\"redis.googleapis.com/stats/memory/usage\" resource.type=\"redis_instance\" resource.label.\"instance_id\"=\"${var.redis_instance_id}\""
#       comparison      = "COMPARISON_GT"
#       threshold_value = var.memory_threshold_bytes
#       duration        = "60s"
#       trigger {
#         count = 1
#       }
#     }
#   }
#   notification_channels = [google_monitoring_notification_channel.email.id]
# }
# resource "google_monitoring_alert_policy" "evictions" {
#   display_name = "${var.environment} - Redis Evictions > 0"
#   combiner     = "OR"
#   conditions {
#     display_name = "Evictions > 0"
#     condition_threshold {
#       filter          = "metric.type=\"redis.googleapis.com/stats/evicted_keys\" resource.type=\"redis_instance\" resource.label.\"instance_id\"=\"${var.redis_instance_id}\""
#       comparison      = "COMPARISON_GT"
#       threshold_value = 0
#       duration        = "60s"
#       trigger {
#         count = 1
#       }
#       aggregations {
#         alignment_period     = "60s"
#         per_series_aligner   = "ALIGN_RATE"
#         cross_series_reducer = "REDUCE_NONE"g
#       }
#     }
#   }
#   user_labels = {
#     project_id    = var.project_id
#     context       = "redis"
#     instance_id   = var.redis_instance_id
#     resource_type = "redis_instance"
#     region        = var.region
#   }
#   notification_channels = [google_monitoring_notification_channel.email.id]
# }
