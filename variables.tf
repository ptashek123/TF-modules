variable "cilium" {
  type = object({
    version          = optional(string, "1.19.5")
    helm_repository  = optional(string, "oci://xD")
    image_repository = optional(string, "oci://xD")
    master_node      = optional(string, "127.0.0.1")
    hubble_host      = string
    cluster_domain   = string

    egress = object({
      enabled = optional(bool, false)
      nodes   = list(string)
    })

    gatewayapi = object({
      enabled = optional(bool, false)
      version = optional(string, "1.5.1")
    })

    ingress = object({
      enabled = optional(bool, false)
      node_label = optional(object({
        key   = optional(string, "node-role.kubernetes.io/ingress")
        value = optional(string, "")
      }), {})
    })
  })
}

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

variable "cert_manager" {
  description = "cert-manager configuration"
  type = object({
    enabled = bool

    namespace = optional(string, "cert-manager")

    install_crds                      = optional(bool, true)
    prometheus_enabled                = optional(bool, false)
    prometheus_servicemonitor_enabled = optional(bool, false)
    webhook_timeout_seconds           = optional(number, 30)

    chart_src = optional(object({
      repo    = optional(string, "oci://xD")
      version = optional(string, "v1.17.2")
    }), {})

    extra_values = optional(any, {})

    cluster_issuers = optional(list(object({
      name = string
      spec = any
    })), [])
  })

  default = {
    enabled = false
  }
}