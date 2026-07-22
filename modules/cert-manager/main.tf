resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  repository       = var.chart_src.repo
  version          = var.chart_src.version
  namespace        = kubernetes_namespace_v1.cert_manager.metadata[0].name
  atomic           = true
  force_update     = true
  cleanup_on_fail  = true
  create_namespace = false

  values = [
    yamlencode(merge(
      {
        installCRDs = var.install_crds
        prometheus = {
          enabled = var.prometheus_enabled
          servicemonitor = {
            enabled = var.prometheus_servicemonitor_enabled
          }
        }
        webhook = {
          timeoutSeconds = var.webhook_timeout_seconds
        }
      },
      var.extra_values,
    ))
  ]

  depends_on = [kubernetes_namespace_v1.cert_manager]
}

resource "kubernetes_manifest" "cluster_issuer" {
  for_each = { for issuer in var.cluster_issuers : issuer.name => issuer }

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = each.value.name
    }
    spec = each.value.spec
  }

  depends_on = [helm_release.cert_manager]
}
