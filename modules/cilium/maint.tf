module "gatewayapi" {
  count          = var.settings.gatewayapi.enabled ? 1 : 0
  source         = "./modules/gatewayapi"
  cilium_version = var.settings.version
}

resource "helm_release" "cilium" {
  name            = "cilium"
  repository      = var.settings.helm_repository
  chart           = "cilium"
  version         = var.settings.version
  namespace       = "kube-system"
  atomic          = true
  force_update    = true
  reuse_values    = true
  cleanup_on_fail = true

  values = [
    templatefile("${path.module}/values/values.yaml", {
      gatewayapi_enabled = var.settings.gatewayapi.enabled
      egress_enabled     = var.settings.egress.enabled
      ingress_enabled    = var.settings.ingress.enabled
      ingress_label      = var.settings.ingress.node_label
      pull_repo          = var.settings.image_repository
      version            = var.settings.version
      master_node        = var.settings.master_node
      hubble_host        = var.settings.hubble_host
      cluster_domain     = var.settings.cluster_domain
    })
  ]
}

module "egress" {
  count      = var.settings.egress.enabled ? 1 : 0
  source     = "./modules/egress"
  nodes      = var.settings.egress.nodes

  depends_on = [helm_release.cilium]
}