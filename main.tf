module "cilium" {
  source   = "./modules/cilium"
  settings = var.cilium
}

module "fluxcd" {
  count      = var.fluxcd.enabled ? 1 : 0
  depends_on = [module.cilium]

  source = "./modules/fluxcd"

  namespace = var.fluxcd.namespace

  #  image_repo_url                = var.image_repo_url
  flux                          = var.fluxcd.flux
  tf_controller_enabled         = var.fluxcd.tf_controller_enabled
  tf_controller                 = var.fluxcd.tf_controller
  flux_chart_src                = var.fluxcd.flux_chart_src
  tf_controller_chart_src       = var.fluxcd.tf_controller_chart_src
  prometheus_podmonitor_enabled = var.fluxcd.prometheus_podmonitor_enabled
  image_automation_enabled      = var.fluxcd.image_automation_enabled
}

module "cert_manager" {
  count  = var.cert_manager.enabled ? 1 : 0
  source = "./modules/cert-manager"

  namespace                         = var.cert_manager.namespace
  install_crds                      = var.cert_manager.install_crds
  prometheus_enabled                = var.cert_manager.prometheus_enabled
  prometheus_servicemonitor_enabled = var.cert_manager.prometheus_servicemonitor_enabled
  webhook_timeout_seconds           = var.cert_manager.webhook_timeout_seconds
  chart_src                         = var.cert_manager.chart_src
  extra_values                      = var.cert_manager.extra_values
  cluster_issuers                   = var.cert_manager.cluster_issuers
}
