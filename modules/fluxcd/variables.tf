variable "namespace" {
  description = "Kubernetes namespace for Flux CD"
  type        = string
  default     = "flux-system"
}

variable "image_repo_url" {
  description = "Base repository image"
  type        = string
  default     = ""
}

variable "flux" {
  description = "Flux CD config"
  type = object({
    log_level            = optional(string, "info")
    watch_all_namespaces = optional(bool, true)
    install_crds         = optional(bool, true)
    cluster_domain       = optional(string, "cluster.local")

    cli = optional(map(string), { create = "true" })
    controllers = optional(object({
      helmController            = optional(map(string), { create = "true" })
      kustomizeController       = optional(map(string), { create = "true" })
      sourceController          = optional(map(string), { create = "true" })
      notificationController    = optional(map(string), { create = "true" })
      imageAutomationController = optional(map(string), { create = "true" })
      imageReflectionController = optional(map(string), { create = "true" })
    }), {})

    multitenancy = optional(object({
      enabled                 = optional(bool, false)
      default_service_account = optional(string, "default")
      privileged              = optional(bool, true)
    }), {})

    extra_values = optional(any, {})
  })

  default = {}
}

variable "tf_controller_enabled" {
  description = "Enable tf-controller"
  type        = bool
  default     = true
}

variable "tf_controller" {
  description = "tf-controller config"
  type = object({
    image = optional(map(string), {})
    runner = optional(object({
      image              = optional(map(string), {})
      allowed_namespaces = optional(list(string), [])
      resources          = optional(map(string), {})
    }), {})
    awsPackage = optional(object({
      install = optional(bool, false)
    }), {})

    extra_values = optional(any, {})
  })

  default = {}
}

variable "flux_chart_src" {
  description = "Source of Flux chart"
  type = object({
    repo    = optional(string, "oci://")
    version = optional(string, "2.18.4")
  })

  default = {}
}

variable "tf_controller_chart_src" {
  description = "Source of tf-controller chart"
  type = object({
    repo    = optional(string, "oci://")
    version = optional(string, "0.16.4")
  })

  default = {}
}

variable "git_conf" {
  description = "GitRepository config"
  type = object({
    interval   = optional(string, "3m")
    branch     = optional(string, "main")
    tag        = optional(string, null)
    secret_ref = optional(string, null)
    extra_spec = optional(any, {})
  })
  default = {}
}

variable "kustomization" {
  description = "Kustomization config"
  type = object({
    interval   = optional(string, "5m")
    path       = optional(string, "./clusters/production")
    prune      = optional(bool, true)
    validation = optional(string, "client")
    force      = optional(bool, false)
    extra_spec = optional(any, {})
  })
  default = {}
}

variable "prometheus_podmonitor_enabled" {
  description = "PodMonitor enabled"
  type        = bool
  default     = false
}

variable "image_automation_enabled" {
  description = "Image Automation (image-automation-controller) enabled"
  type        = bool
  default     = false
}