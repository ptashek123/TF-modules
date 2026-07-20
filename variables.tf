variable "fluxcd" {
  description = "Flux CD configuration"
  type = object({
    enabled = bool

    namespace = string

    repositories = list(object({
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

    flux = optional(object({
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
    }), {})

    tf_controller_enabled = optional(bool, true)
    tf_controller = optional(object({
      runner = optional(object({
        allowedNamespaces = optional(list(string), [])
        resources         = optional(map(string), {})
      }), {})
      extraValues = optional(any, {})
    }), {})

    flux_chart_src = optional(object({
      repo    = optional(string, "oci://xD")
      version = optional(string, "2.18.4")
    }), {})

    tf_controller_chart_src = optional(object({
      repo    = optional(string, "oci://xD")
      version = optional(string, "0.16.0")
    }), {})

    prometheus_podmonitor_enabled = optional(bool, false)
    image_automation_enabled      = optional(bool, false)
  })
  default = {
    enabled      = false
    namespace    = "flux-system"
    repositories = []
  }
}