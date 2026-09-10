variable "cilium" {
  type = object({
    helm_repository  = optional(string, "oci://")
    image_repository = optional(string, "")
    version          = optional(string, "1.20.0")
    cluster_domain   = optional(string, "cluster.local")
    hubble = optional(object({
      enabled = optional(bool, false)
      ingress = optional(object({
        enabled = optional(bool, false)
        hosts   = optional(list(string), ["example.com"])
        tls = optional(object({
          enabled = optional(bool, false)
          list    = optional(list(object({ secret = string, hosts = list(string) })), [])
        }), {})
      }), {})
    }), {})
    egress = optional(object({
      enabled = optional(bool, false)
      nodes   = optional(list(string), [])
    }), {})
    gatewayapi = optional(object({
      enabled = optional(bool, false)
      node_label = optional(object({
        key   = optional(string, "node-role.kubernetes.io/ingress")
        value = optional(string, "")
      }), {})
    }), {})
    ingress = optional(object({
      enabled = optional(bool, false)
      node_label = optional(object({
        key   = optional(string, "node-role.kubernetes.io/ingress")
        value = optional(string, "")
      }), {})
    }), {})
  })
}

variable "fluxcd" {
  description = "Flux CD configuration"
  type = object({
    enabled = bool

    namespace = string

    repositories = optional(list(object({
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
    })), [])

    flux = optional(object({
      log_level            = optional(string, "info")
      watch_all_namespaces = optional(bool, true)
      install_crds         = optional(bool, true)
      cluster_domain       = optional(string, "cluster.local")
      cli                  = optional(map(string), { image = "", tag = "v2.9.2" })
      controllers = optional(object({
        helmController            = optional(map(string), { image = "", tag = "v1.6.2" })
        kustomizeController       = optional(map(string), { image = "", tag = "v1.9.3" })
        sourceController          = optional(map(string), { image = "", tag = "v1.9.3" })
        notificationController    = optional(map(string), { image = "", tag = "v1.9.2" })
        imageAutomationController = optional(map(string), { image = "", tag = "v1.2.3" })
        imageReflectionController = optional(map(string), { image = "", tag = "v1.2.3" })
      }), {})
      multitenancy = optional(object({
        enabled                 = optional(bool, false)
        default_cervice_account = optional(string, "default")
        privileged              = optional(bool, true)
      }), {})
      extra_values = optional(any, {})
    }), {})

    tf_controller_enabled = optional(bool, true)
    tf_controller = optional(object({
      image = optional(map(string), { repository = "", tag = "v0.16.4" })
      runner = optional(object({
        image              = optional(map(string), { repository = "", tag = "v0.16.4" })
        allowed_namespaces = optional(list(string), [])
        resources          = optional(map(string), {})
      }), {})
      awsPackage = optional(object({
        install = optional(bool, false)
      }), {})
      extravalues = optional(any, {})
    }), {})

    flux_chart_src = optional(object({
      repo    = optional(string, "")
      version = optional(string, "2.18.4")
    }), {})

    tf_controller_chart_src = optional(object({
      repo    = optional(string, "")
      version = optional(string, "0.16.4")
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
      repo    = optional(string, "oci://")
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