variable "repository" {
  type    = string
  default = "ossi/headlamp"
}

variable "in_cluster_context_name" {
  type    = string
  default = "kubernetes-admin@cluster.local"
}

variable "oidc_client_id" {
  type    = string
  default = "keycloak-headlamp"
}

variable "oidc_client_secret" {
  type    = string
  default = "xxxx"
}

variable "oidc_issuer_url" {
  type = string
}

variable "oidc_scopes" {
  type    = string
  default = "openid,profile,email,offline_access"
}

variable "oidc_use_pkce" {
  type    = string
  default = "true"
}

variable "helm" {
  type = object({
    repository = string
    version    = string
  })
}

variable "ingress" {
  type = object({
    host = string
    path = string
    tls = object({
      enabled     = bool
      secret_name = string
    })
  })
}

variable "headlamp_plugins" {
  type = list(object({
    name  = string
    image = string
  }))

  default = []
}
