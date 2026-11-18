variable "namespace" {
  description = "Kubernetes namespace for Vault Operator"
  type        = string
  default     = "vault-operator"
}

variable "image_repo_url" {
  description = "Base repository image URL"
  type        = string
  default     = "harbor.bank.srv/k8splatform-repo"
}

variable "vault_operator" {
  description = "Vault Operator configuration"
  type = object({
    image_tag  = optional(string, "v0.0.2")
    image_path = optional(string, "vault-secret-controller")

    replica_count = optional(number, 1)

    resources = optional(object({
      limits = optional(object({
        cpu    = optional(string, "500m")
        memory = optional(string, "128Mi")
      }), {})
      requests = optional(object({
        cpu    = optional(string, "10m")
        memory = optional(string, "64Mi")
      }), {})
    }), {})

    leader_elect = optional(bool, true)

    crd = optional(object({
      create = optional(bool, true)
    }), {})

    metrics_service = optional(object({
      create = optional(bool, true)
      type   = optional(string, "ClusterIP")
    }), {})

    rbac = optional(object({
      create = optional(bool, true)
      cluster_role_bindings = optional(object({
        admin  = optional(bool, false)
        editor = optional(bool, false)
        viewer = optional(bool, false)
      }), {})
    }), {})

    service_account = optional(object({
      create      = optional(bool, true)
      name        = optional(string, "")
      annotations = optional(map(string), {})
    }), {})

    pod_annotations = optional(map(string), {})
    pod_labels      = optional(map(string), {})
    node_selector   = optional(map(string), {})
    tolerations     = optional(any, [])
    affinity        = optional(any, {})

    extra_values = optional(any, {})
  })

  default = {}
}

variable "chart_src" {
  description = "Source of Vault Operator chart"
  type = object({
    repo    = optional(string, "xD")
    version = optional(string, "0.1.0")
  })

  default = {}
}
