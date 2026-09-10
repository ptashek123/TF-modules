resource "helm_release" "headlamp" {
  name             = "headlamp"
  chart            = "headlamp"
  repository       = var.helm.repository
  version          = var.helm.version
  namespace        = "headlamp"
  create_namespace = true
  atomic           = true
  force_update     = true
  reuse_values     = true
  cleanup_on_fail  = true
  values = [templatefile("${path.module}/values/values.yaml", {
    repository              = var.repository
    in_cluster_context_name = var.in_cluster_context_name
    oidc_client_id          = var.oidc_client_id
    oidc_client_secret      = var.oidc_client_secret
    oidc_issuer_url         = var.oidc_issuer_url
    oidc_scopes             = var.oidc_scopes
    oidc_use_pkce           = var.oidc_use_pkce
    headlamp_plugins        = var.headlamp_plugins
    ingress                 = var.ingress
  })]
}
