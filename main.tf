module "fluxcd" {
  count      = var.fluxcd.enabled ? 1 : 0
  depends_on = [module.cilium]

  source = "./modules/fluxcd"

  namespace    = var.fluxcd.namespace
  repositories = var.fluxcd.repositories

  flux                          = var.fluxcd.flux
  tf_controller_enabled         = var.fluxcd.tf_controller_enabled
  tf_controller                 = var.fluxcd.tf_controller
  flux_chart_src                = var.fluxcd.flux_chart_src
  tf_controller_chart_src       = var.fluxcd.tf_controller_chart_src
  prometheus_podmonitor_enabled = var.fluxcd.prometheus_podmonitor_enabled
  image_automation_enabled      = var.fluxcd.image_automation_enabled
}