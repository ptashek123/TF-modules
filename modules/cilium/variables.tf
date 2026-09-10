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

  #Validate cilium versions
  validation {
    condition     = contains(["1.20.0"], var.cilium.version)
    error_message = "Cilium version must be 1.20.0"
  }
  #Validate hubble ingress hosts
  validation {
    condition     = alltrue([for d in var.cilium.hubble.ingress.hosts : !var.cilium.hubble.ingress.enabled || (can(regex("^[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", d)) && length(d) <= 253 && !contains(split(".", d), ""))])
    error_message = "Bad domains for hubble"
  }
  #Validate egress nodes when egress enabled
  validation {
    condition     = !var.cilium.egress.enabled || (var.cilium.egress.enabled && length(var.cilium.egress.nodes) > 0)
    error_message = "When egress is enabled, egress nodes must not be empty"
  }
  #Validate egress nodes when egress enabled
  validation {
    condition     = (!var.cilium.hubble.ingress.tls.enabled) || (var.cilium.hubble.ingress.tls.enabled && length(var.cilium.hubble.ingress.tls.list) > 0)
    error_message = "Hubble ingress tls list must not be empty"
  }
}