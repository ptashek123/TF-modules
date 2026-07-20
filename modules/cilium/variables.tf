variable "settings" {
  type = object({
    helm_repository  = string
    image_repository = string
    version          = string
    master_node      = string
    hubble_host      = string
    cluster_domain   = string

    egress = object({
      enabled = bool
      nodes   = list(string)
    })

    gatewayapi = object({
      enabled = bool
      version = string
    })

    ingress = object({
      enabled = bool
      node_label = object({
        key   = string
        value = string
      })
    })
  })
  
  validation {
    condition     = contains(["1.19.4", "1.19.5"], var.settings.version)
    error_message = "Cilium version must be 1.19.4 or 1.19.5"
  }
}