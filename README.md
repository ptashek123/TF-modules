# TF-modules

Various READY-TO-USE Terraform modules


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.15.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 3.1.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 3.0.1 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 5.4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_cilium"></a> [cilium](#module\_cilium) | ./modules/cilium | n/a |
| <a name="module_fluxcd"></a> [fluxcd](#module\_fluxcd) | ./modules/fluxcd | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cert_manager"></a> [cert\_manager](#input\_cert\_manager) | cert-manager configuration | <pre>object({<br/>    enabled = bool<br/><br/>    namespace = optional(string, "cert-manager")<br/><br/>    install_crds                      = optional(bool, true)<br/>    prometheus_enabled                = optional(bool, false)<br/>    prometheus_servicemonitor_enabled = optional(bool, false)<br/>    webhook_timeout_seconds           = optional(number, 30)<br/><br/>    chart_src = optional(object({<br/>      repo    = optional(string, "oci://")<br/>      version = optional(string, "v1.17.2")<br/>    }), {})<br/><br/>    extra_values = optional(any, {})<br/><br/>    cluster_issuers = optional(list(object({<br/>      name = string<br/>      spec = any<br/>    })), [])<br/>  })</pre> | <pre>{<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_cilium"></a> [cilium](#input\_cilium) | n/a | <pre>object({<br/>    helm_repository  = optional(string, "oci://")<br/>    image_repository = optional(string, "")<br/>    version          = optional(string, "1.20.0")<br/>    cluster_domain   = optional(string, "cluster.local")<br/>    hubble = optional(object({<br/>      enabled = optional(bool, false)<br/>      ingress = optional(object({<br/>        enabled = optional(bool, false)<br/>        hosts   = optional(list(string), ["example.com"])<br/>        tls = optional(object({<br/>          enabled = optional(bool, false)<br/>          list    = optional(list(object({ secret = string, hosts = list(string) })), [])<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    egress = optional(object({<br/>      enabled = optional(bool, false)<br/>      nodes   = optional(list(string), [])<br/>    }), {})<br/>    gatewayapi = optional(object({<br/>      enabled = optional(bool, false)<br/>      node_label = optional(object({<br/>        key   = optional(string, "node-role.kubernetes.io/ingress")<br/>        value = optional(string, "")<br/>      }), {})<br/>    }), {})<br/>    ingress = optional(object({<br/>      enabled = optional(bool, false)<br/>      node_label = optional(object({<br/>        key   = optional(string, "node-role.kubernetes.io/ingress")<br/>        value = optional(string, "")<br/>      }), {})<br/>    }), {})<br/>  })</pre> | n/a | yes |
| <a name="input_fluxcd"></a> [fluxcd](#input\_fluxcd) | Flux CD configuration | <pre>object({<br/>    enabled = bool<br/><br/>    namespace = string<br/><br/>    repositories = optional(list(object({<br/>      name              = string<br/>      url               = string<br/>      branch            = optional(string, "main")<br/>      tag               = optional(string, null)<br/>      path              = string<br/>      secret_vault_path = string<br/>      target_namespace  = optional(string)<br/>      interval          = optional(string, "3m")<br/>      kustomization = optional(object({<br/>        interval   = optional(string, "5m")<br/>        prune      = optional(bool, true)<br/>        validation = optional(string, "client")<br/>        force      = optional(bool, false)<br/>      }), {})<br/>    })), [])<br/><br/>    flux = optional(object({<br/>      log_level            = optional(string, "info")<br/>      watch_all_namespaces = optional(bool, true)<br/>      install_crds         = optional(bool, true)<br/>      cluster_domain       = optional(string, "cluster.local")<br/>      cli                  = optional(map(string), { image = "", tag = "v2.9.2" })<br/>      controllers = optional(object({<br/>        helmController            = optional(map(string), { image = "", tag = "v1.6.2" })<br/>        kustomizeController       = optional(map(string), { image = "", tag = "v1.9.3" })<br/>        sourceController          = optional(map(string), { image = "", tag = "v1.9.3" })<br/>        notificationController    = optional(map(string), { image = "", tag = "v1.9.2" })<br/>        imageAutomationController = optional(map(string), { image = "", tag = "v1.2.3" })<br/>        imageReflectionController = optional(map(string), { image = "", tag = "v1.2.3" })<br/>      }), {})<br/>      multitenancy = optional(object({<br/>        enabled                 = optional(bool, false)<br/>        default_cervice_account = optional(string, "default")<br/>        privileged              = optional(bool, true)<br/>      }), {})<br/>      extra_values = optional(any, {})<br/>    }), {})<br/><br/>    tf_controller_enabled = optional(bool, true)<br/>    tf_controller = optional(object({<br/>      image = optional(map(string), { repository = "", tag = "v0.16.4" })<br/>      runner = optional(object({<br/>        image              = optional(map(string), { repository = "", tag = "v0.16.4" })<br/>        allowed_namespaces = optional(list(string), [])<br/>        resources          = optional(map(string), {})<br/>      }), {})<br/>      awsPackage = optional(object({<br/>        install = optional(bool, false)<br/>      }), {})<br/>      extravalues = optional(any, {})<br/>    }), {})<br/><br/>    flux_chart_src = optional(object({<br/>      repo    = optional(string, "")<br/>      version = optional(string, "2.18.4")<br/>    }), {})<br/><br/>    tf_controller_chart_src = optional(object({<br/>      repo    = optional(string, "")<br/>      version = optional(string, "0.16.4")<br/>    }), {})<br/><br/>    prometheus_podmonitor_enabled = optional(bool, false)<br/>    image_automation_enabled      = optional(bool, false)<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "namespace": "flux-system",<br/>  "repositories": []<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->