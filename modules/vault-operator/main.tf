resource "kubernetes_namespace_v1" "vault_operator" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "vault_operator" {
  name       = "vault-operator"
  chart      = "vault-operator"
  repository = var.chart_src.repo
  version    = var.chart_src.version
  namespace  = kubernetes_namespace_v1.vault_operator.metadata[0].name

  values = [
    yamlencode({
      image = {
        repository = "${var.image_repo_url}/${var.vault_operator.image_path}"
        tag        = var.vault_operator.image_tag
        pullPolicy = "IfNotPresent"
      }
      replicaCount = var.vault_operator.replica_count

      resources = var.vault_operator.resources

      leaderElect = var.vault_operator.leader_elect

      crd = var.vault_operator.crd

      metricsService = var.vault_operator.metrics_service

      rbac = var.vault_operator.rbac

      serviceAccount = var.vault_operator.service_account

      podAnnotations = var.vault_operator.pod_annotations
      podLabels      = var.vault_operator.pod_labels
      nodeSelector   = var.vault_operator.node_selector
      tolerations    = var.vault_operator.tolerations
      affinity       = var.vault_operator.affinity
    }),
    yamlencode(var.vault_operator.extra_values)
  ]

  depends_on = [
    kubernetes_namespace_v1.vault_operator
  ]
}
