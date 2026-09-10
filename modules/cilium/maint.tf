module "gatewayapi" {
  count          = var.cilium.gatewayapi.enabled ? 1 : 0
  source         = "./modules/gatewayapi"
  cilium_version = var.cilium.version
}

resource "helm_release" "cilium" {
  name            = "cilium"
  repository      = var.cilium.helm_repository
  chart           = "cilium"
  version         = var.cilium.version
  namespace       = "kube-system"
  atomic          = false
  force_update    = false
  reuse_values    = true
  cleanup_on_fail = false
  timeout         = 1200
  values = [
    templatefile("${path.module}/values/default.yaml", {
      cilium = var.cilium
    }),
    templatefile("${path.module}/values/hubble.yaml", {
      cluster_domain   = var.cilium.cluster_domain
      image_repository = var.cilium.image_repository
      hubble           = var.cilium.hubble
    })
  ]
}

module "egress" {
  depends_on = [helm_release.cilium]
  count      = var.cilium.egress.enabled ? 1 : 0
  source     = "./modules/egress"
  nodes      = var.cilium.egress.nodes
}