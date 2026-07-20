resource "kubernetes_namespace_v1" "flux" {
  metadata {
    name = var.namespace
  }
}

data "vault_generic_secret" "git_creds" {
  for_each = { for idx, repo in var.repositories : repo.name => repo }
  path     = each.value.secret_vault_path
}

resource "kubernetes_secret_v1" "git_auth" {
  for_each = { for idx, repo in var.repositories : repo.name => repo }

  metadata {
    name      = "git-auth-${each.key}"
    namespace = kubernetes_namespace_v1.flux.metadata[0].name
  }
  type = "Opaque"
  data = {
    username = data.vault_generic_secret.git_creds[each.key].data["username"]
    password = data.vault_generic_secret.git_creds[each.key].data["password"]
  }
  depends_on = [kubernetes_namespace_v1.flux]
}

resource "helm_release" "fluxcd" {
  name       = "fluxcd"
  chart      = "flux2"
  repository = var.flux_chart_src.repo
  version    = var.flux_chart_src.version
  namespace  = kubernetes_namespace_v1.flux.metadata[0].name

  values = [
    yamlencode({
      logLevel           = var.flux.logLevel
      watchAllNamespaces = var.flux.watchAllNamespaces
      installCRDs        = var.flux.installCRDs
      clusterDomain      = var.flux.clusterDomain
      controllers        = var.flux.controllers
      multitenancy       = var.flux.multitenancy
      extraValues        = var.flux.extraValues

      prometheus = var.prometheus_podmonitor_enabled ? { PodMonitor = { enabled = true } } : {}

      imageAutomation = var.image_automation_enabled ? { enabled = true } : {}
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.flux,
    kubernetes_secret_v1.git_auth,
  ]
}

resource "helm_release" "tf_controller" {
  count      = var.tf_controller_enabled ? 1 : 0
  name       = "tf-controller"
  chart      = "tofu-controller"
  repository = var.tf_controller_chart_src.repo
  version    = var.flux_chart_src.version
  namespace  = kubernetes_namespace_v1.flux.metadata[0].name

  values = [
    yamlencode({
      runner      = var.tf_controller.runner
      extraValues = var.tf_controller.extraValues
    })
  ]

  depends_on = [helm_release.fluxcd]
}

resource "kubernetes_manifest" "git_repository" {
  for_each = { for idx, repo in var.repositories : repo.name => repo }

  manifest = {
    apiVersion = "source.toolkit.fluxcd.io/v1"
    kind       = "GitRepository"
    metadata = {
      name      = each.key
      namespace = kubernetes_namespace_v1.flux.metadata[0].name
    }
    spec = {
      interval = each.value.interval
      url      = each.value.url
      ref = {
        branch = each.value.branch
        tag    = each.value.tag
      }
      secretRef = {
        name = kubernetes_secret_v1.git_auth[each.key].metadata[0].name
      }
    }
  }

  depends_on = [helm_release.fluxcd]
}

resource "kubernetes_manifest" "kustomization" {
  for_each = { for idx, repo in var.repositories : repo.name => repo }

  manifest = {
    apiVersion = "kustomize.toolkit.fluxcd.io/v1"
    kind       = "Kustomization"
    metadata = {
      name      = each.key
      namespace = kubernetes_namespace_v1.flux.metadata[0].name
    }
    spec = {
      interval   = lookup(each.value.kustomization, "interval", "5m")
      path       = each.value.path
      prune      = lookup(each.value.kustomization, "prune", true)
      validation = lookup(each.value.kustomization, "validation", "client")
      force      = lookup(each.value.kustomization, "force", false)
      sourceRef = {
        kind      = "GitRepository"
        name      = each.key
        namespace = kubernetes_namespace_v1.flux.metadata[0].name
      }
      target_namespace = each.value.target_namespace
    }
  }

  depends_on = [kubernetes_manifest.git_repository]
}