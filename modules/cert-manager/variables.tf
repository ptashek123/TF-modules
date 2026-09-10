variable "namespace" {
  description = "Kubernetes namespace for cert-manager"
  type        = string
  default     = "cert-manager"
}

variable "install_crds" {
  description = "Install cert-manager CRDs as part of the Helm release"
  type        = bool
  default     = true
}

variable "prometheus_enabled" {
  description = "Enable Prometheus metrics for cert-manager"
  type        = bool
  default     = false
}

variable "prometheus_servicemonitor_enabled" {
  description = "Create ServiceMonitor resources for Prometheus Operator"
  type        = bool
  default     = false
}

variable "webhook_timeout_seconds" {
  description = "Timeout in seconds for the cert-manager webhook"
  type        = number
  default     = 30
}

variable "chart_src" {
  description = "Source of cert-manager Helm chart"
  type = object({
    repo    = optional(string, "oci://")
    version = optional(string, "v1.21.0")
  })

  default = {}
}

variable "extra_values" {
  description = "Additional Helm values merged into the cert-manager release"
  type        = any
  default     = {}
}

variable "cluster_issuers" {
  description = "ClusterIssuer resources to create after cert-manager is installed"
  type = list(object({
    name = string
    spec = any
  }))
  default = []
}
