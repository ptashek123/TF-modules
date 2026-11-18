variable "namespace" {
  description = "Kubernetes namespace for Victoria Metrics Agent"
  type        = string
  default     = "victoria-metrics"
}

variable "chart_src" {
  description = "Source of Victoria Metrics Agent chart"
  type = object({
    repo    = optional(string, "xD")
    version = optional(string, "0.47.0")
  })

  default = {}
}

variable "kafka_enabled" {
  description = "Enable Kafka as metrics sink"
  type        = bool
  default     = false
}

variable "kafka_brokers" {
  description = "Kafka brokers address for metrics output (comma-separated)"
  type        = string
  default     = "kafka-kafka-brokers.monitoring:9092"
  validation {
    condition     = !var.kafka_enabled || (var.kafka_brokers != "" && var.kafka_topic != "")
    error_message = "The ${join(", ", [for name in ["kafka_brokers", "kafka_topic"] : name if name == ""])} must not be empty when kafka_enabled is true"
  }
}

variable "kafka_topic" {
  description = "Kafka topic for metrics"
  type        = string
  default     = "victoria-metrics"
}

variable "prometheus_enabled" {
  description = "Enable direct Prometheus push as metrics sink"
  type        = bool
  default     = false
  validation {
    condition     = !var.prometheus_enabled && !var.kafka_enabled
    error_message = "You can enable only one - Prometheus or Kafka"
  }
}

variable "prometheus_url" {
  description = "Prometheus URL for direct metrics push (e.g., http://prometheus:9090)"
  type        = string
  default     = ""

  validation {
    condition     = !var.prometheus_enabled && var.prometheus_url != ""
    error_message = "The prometheus_url must not be empty when prometheus_enabled is true"
  }
}

variable "logger_level" {
  description = "Logger level"
  type        = string
  default     = "INFO"
}

variable "logger_format" {
  description = "Logger format"
  type        = string
  default     = "pretty"
}

variable "resources" {
  description = "Resource limits and requests for Victoria Metrics Agent"
  type = object({
    requests = optional(object({
      cpu    = optional(string, "100m")
      memory = optional(string, "128Mi")
    }), {})
    limits = optional(object({
      cpu    = optional(string, "500m")
      memory = optional(string, "512Mi")
    }), {})
  })
  default = {}
}

variable "affinity" {
  description = "Affinity rules for Victoria Metrics Agent"
  type        = any
  default     = {}
}

variable "tolerations" {
  description = "Tolerations for Victoria Metrics Agent"
  type        = any
  default     = []
}

variable "node_selector" {
  description = "Node selector for Victoria Metrics Agent"
  type        = map(string)
  default     = {}
}

variable "service_monitor_enabled" {
  description = "Enable ServiceMonitor for Victoria Metrics Agent self-monitoring"
  type        = bool
  default     = false
}

variable "pod_annotations" {
  description = "Additional pod annotations"
  type        = map(string)
  default     = {}
}

variable "extra_env" {
  description = "Additional environment variables"
  type        = any
  default     = []
}

variable "extra_volumes" {
  description = "Additional volumes"
  type        = any
  default     = []
}

variable "extra_volume_mounts" {
  description = "Additional volume mounts"
  type        = any
  default     = []
}

variable "extra_args" {
  description = "Additional extraArgsMap for Victoria Metrics Agent"
  type        = map(string)
  default     = {}
}

variable "extra_values" {
  description = "Extra values to merge into the helm release"
  type        = any
  default     = {}
}
