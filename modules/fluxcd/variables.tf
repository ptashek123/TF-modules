variable "namespace" {
  description = "Kubernetes namespace for Flux CD"
  type        = string
  default     = "flux-system"
}

variable "repositories" {
  description = "List of Git repositories to be managed by Flux. Each repository requires Vault path for credentials."
  type = list(object({
    username          = optional(string, null)
    password          = optional(string, null)
    name              = string
    url               = string
    branch            = optional(string, "main")
    tag               = optional(string, null)
    path              = string
    secret_vault_path = string
    target_namespace  = optional(string)
    interval          = optional(string, "3m")
    kustomization = optional(object({
      interval   = optional(string, "5m")
      prune      = optional(bool, true)
      validation = optional(string, "client")
      force      = optional(bool, false)
    }), {})
  }))

  validation {
    condition     = alltrue([for r in var.repositories : r.secret_vault_path != ""])
    error_message = "Each repository must specify a non-empty secret_vault_path."
  }

  validation {
    condition     = alltrue([for r in var.repositories : r.target_namespace != "kube-system" if r.target_namespace != null])
    error_message = "Deploying to the 'kube-system' namespace is strictly prohibited for security reasons."
  }
}

variable "flux" {
  description = "Flux CD config"
  type = object({
    logLevel           = optional(string, "info")
    watchAllNamespaces = optional(bool, true)
    installCRDs        = optional(bool, true)
    clusterDomain      = optional(string, "cluster.local")

    controllers = optional(object({
      helmController            = optional(map(string), {})
      kustomizeController       = optional(map(string), {})
      sourceController          = optional(map(string), {})
      notificationController    = optional(map(string), {})
      imageAutomationController = optional(map(string), {})
      imageReflectionController = optional(map(string), {})
    }), {})

    multitenancy = optional(object({
      enabled               = optional(bool, false)
      defaultServiceAccount = optional(string, "default")
      privileged            = optional(bool, true)
    }), {})

    extraValues = optional(any, {})
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
    runner = optional(object({
      allowedNamespaces = optional(list(string), [])
      resources         = optional(map(string), {})
    }), {})

    extraValues = optional(any, {})
  })

  default = {}
}

variable "flux_chart_src" {
  description = "Source of Flux chart"
  type = object({
    repo    = optional(string, "oci://xD")
    version = optional(string, "2.18.4")
  })

  default = {}
}

variable "tf_controller_chart_src" {
  description = "Source of tf-controller chart"
  type = object({
    repo    = optional(string, "oci://xD")
    version = optional(string, "0.16.0")
  })

  default = {}
}

variable "git_conf" {
  description = "GitRepository config"
  type = object({
    interval  = optional(string, "3m")
    branch    = optional(string, "main")
    tag       = optional(string, null)
    secretRef = optional(string, null)
    extraSpec = optional(any, {})
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
    extraSpec  = optional(any, {})
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