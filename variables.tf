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

variable "rbac" {
  type = object({
    enabled = optional(bool, true)
    roles = map(object({
      namespace = optional(string, "default")
      rules = list(object({
        api_groups     = optional(list(string), [""])
        resources      = list(string)
        verbs          = list(string)
        resource_names = optional(list(string), [])
      }))
      annotations = optional(map(string), {})
      labels      = optional(map(string), {})
    }))
    role_bindings = map(object({
      namespace = optional(string, "default")
      role_ref = object({
        api_group = optional(string, "rbac.authorization.k8s.io")
        kind      = string
        name      = string
      })
      subjects = list(object({
        kind      = string
        name      = string
        namespace = optional(string, "")
        api_group = optional(string, "rbac.authorization.k8s.io")
      }))
      annotations = optional(map(string), {})
      labels      = optional(map(string), {})
    }))
    cluster_roles = map(object({
      rules = list(object({
        api_groups        = optional(list(string), [""])
        resources         = list(string)
        verbs             = list(string)
        resource_names    = optional(list(string), [])
        non_resource_urls = optional(list(string), [])
      }))
      annotations = optional(map(string), {})
      labels      = optional(map(string), {})
    }))
    cluster_role_bindings = map(object({
      role_ref = object({
        api_group = optional(string, "rbac.authorization.k8s.io")
        kind      = string
        name      = string
      })
      subjects = list(object({
        kind      = string
        name      = string
        namespace = optional(string, "")
        api_group = optional(string, "rbac.authorization.k8s.io")
      }))
      annotations = optional(map(string), {})
      labels      = optional(map(string), {})
    }))

  })
}

variable "headlamp" {
  type = object({
    helm = optional(object({
      repository = optional(string, "oci://")
      version    = optional(string, "0.39.0")
    }), {})
    enabled                 = bool
    repository              = optional(string, "")
    in_cluster_context_name = string
    oidc_client_id          = optional(string, "keycloak-headlamp")
    oidc_client_secret      = optional(string, "xxxx")
    oidc_issuer_url         = optional(string, "https://keycloak")
    oidc_scopes             = optional(string, "openid,profile,email,offline_access")
    oidc_use_pkce           = optional(string, "true")
    ingress = optional(object({
      host = optional(string, "localhost")
      path = optional(string, "/")
      tls = optional(object({
        enabled     = optional(bool, false)
        secret_name = optional(string, "")
      }))
    }), {})
    headlamp_plugins = optional(list(object({
      name  = optional(string, "")
      image = optional(string, "")
    })))
  })
  default = {
    enabled                 = false
    in_cluster_context_name = ""
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

variable "vault_operator" {
  description = "Vault Operator configuration"
  type = object({
    enabled   = optional(bool, false)
    namespace = optional(string, "vault-operator")

    config = optional(object({
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
    }), {})

    chart_src = optional(object({
      repo    = optional(string, "xD")
      version = optional(string, "0.1.0")
    }), {})
  })

  default = {
    enabled   = false
    namespace = "vault-operator"
  }
}
