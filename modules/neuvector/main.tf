resource "helm_release" "neuvector" {
  name             = "neuvector"
  chart            = "core"
  repository       = var.helm.repository
  version          = var.helm.version
  namespace        = "neuvector"
  create_namespace = true
  atomic           = true
  force_update     = true
  reuse_values     = true
  cleanup_on_fail  = true
  values = [templatefile("${path.module}/values/values.yaml", {
    repository = var.repository
  })]
}
