resource "kubernetes_namespace_v1" "vma" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "victoria_metrics_agent" {
  name       = "victoria-metrics-agent"
  chart      = "victoria-metrics-agent"
  repository = var.chart_src.repo
  version    = var.chart_src.version
  namespace  = kubernetes_namespace_v1.vma.metadata[0].name

  values = [
    yamlencode({
      mode = "agent"

      logger = {
        level  = var.logger_level
        format = var.logger_format
      }

      extraArgs = {
        "metricsSinks" = join(",", compact([
          var.kafka_enabled ? "kafka://${var.kafka_brokers}/${var.kafka_topic}" : "",
          var.prometheus_enabled ? "${var.prometheus_url}/api/v1/write" : "",
        ]))
      }

      resources = var.resources

      affinity     = var.affinity
      tolerations  = var.tolerations
      nodeSelector = var.node_selector
      serviceMonitor = var.service_monitor_enabled ? {
        enabled = true
        } : {
        enabled = false
      }

      podAnnotations = var.pod_annotations

      extraEnv          = var.extra_env
      extraVolumes      = var.extra_volumes
      extraVolumeMounts = var.extra_volume_mounts
      extraArgsMap      = var.extra_args
    }),
    yamlencode(var.extra_values)
  ]

  depends_on = [kubernetes_namespace_v1.vma]
}
