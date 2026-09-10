resource "kubernetes_namespace_v1" "flux" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "fluxcd" {
  name       = "fluxcd"
  chart      = "flux2"
  repository = var.flux_chart_src.repo
  version    = var.flux_chart_src.version
  namespace  = kubernetes_namespace_v1.flux.metadata[0].name

  values = [
    yamlencode({
      logLevel           = var.flux.log_level
      watchAllNamespaces = var.flux.watch_all_namespaces
      installCrds        = var.flux.install_crds
      clusterDomain      = var.flux.cluster_domain
      # controllers               = var.flux.controllers
      cli = {
        image = coalesce(
          try(var.flux.cli["image"], null),
          try("${var.image_repo_url}${var.flux.cli["image_path"]}", null)
        )
        tag = try(var.flux.cli["tag"], null)
      }

      multitenancy              = var.flux.multitenancy
      prometheus                = var.prometheus_podmonitor_enabled ? { podMonitor = { enabled = true } } : {}
      imageAutomationController = var.image_automation_enabled ? { create = true } : {}
    }),
    yamlencode({
      for name, ctrl in var.flux.controllers : name => {
        create = try(ctrl["create"], "true")
        image = coalesce(
          try(ctrl["image"], null),
          try("${var.image_repo_url}${ctrl["image_path"]}", null)
        )
        tag = try(ctrl["tag"], null)
      }
    }),
    yamlencode(var.flux.extra_values)
  ]

  depends_on = [
    kubernetes_namespace_v1.flux
  ]
}

resource "helm_release" "tf_controller" {
  count      = var.tf_controller_enabled ? 1 : 0
  name       = "tf-controller"
  chart      = "tofu-controller"
  repository = var.tf_controller_chart_src.repo
  version    = var.tf_controller_chart_src.version
  namespace  = kubernetes_namespace_v1.flux.metadata[0].name

  values = [
    yamlencode({
      image        = var.tf_controller.image
      runner       = var.tf_controller.runner
      extra_values = var.tf_controller.extra_values
      awsPackage   = var.tf_controller.awsPackage
    })
  ]

  depends_on = [helm_release.fluxcd]
}