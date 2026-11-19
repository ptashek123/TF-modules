resource "helm_release" "kyverno" {
  name             = "kyverno"
  chart            = "kyverno"
  repository       = var.helm.repository
  version          = var.helm.version
  create_namespace = true
  namespace        = "kyverno"
  atomic           = true
  force_update     = false
  reuse_values     = true
  cleanup_on_fail  = true
  timeout          = 120
  values = [templatefile("${path.module}/templates/values.yaml", {
    registry = var.registry
  })]
}
