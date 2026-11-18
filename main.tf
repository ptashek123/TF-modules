module "cilium" {
  source = "./modules/cilium"
  cilium = var.cilium
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

module "rbac" {
  count                 = var.rbac.enabled ? 1 : 0
  source                = "./modules/rbac"
  roles                 = var.rbac.roles
  role_bindings         = var.rbac.role_bindings
  cluster_roles         = var.rbac.cluster_roles
  cluster_role_bindings = var.rbac.cluster_role_bindings
}

module "headlamp" {
  count                   = var.headlamp.enabled ? 1 : 0
  source                  = "./modules/headlamp"
  repository              = var.headlamp.repository
  helm                    = var.headlamp.helm
  in_cluster_context_name = var.headlamp.in_cluster_context_name
  oidc_client_id          = var.headlamp.oidc_client_id
  oidc_client_secret      = var.headlamp.oidc_client_secret
  oidc_issuer_url         = var.headlamp.oidc_issuer_url
  oidc_scopes             = var.headlamp.oidc_scopes
  oidc_use_pkce           = var.headlamp.oidc_use_pkce
  ingress                 = var.headlamp.ingress
  headlamp_plugins        = var.headlamp.headlamp_plugins
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

module "vault_operator" {
  count      = var.vault_operator.enabled ? 1 : 0
  depends_on = [module.cilium]
  source     = "./modules/vault-operator"

  namespace      = var.vault_operator.namespace
  vault_operator = var.vault_operator.config
  chart_src      = var.vault_operator.chart_src
}

module "victoria_metrics_agent" {
  count      = var.victoria_metrics_agent.enabled ? 1 : 0
  depends_on = [module.cilium]
  source     = "./modules/victoria-metrics-agent"

  namespace               = var.victoria_metrics_agent.namespace
  chart_src               = var.victoria_metrics_agent.chart_src
  kafka_enabled           = var.victoria_metrics_agent.kafka_enabled
  kafka_brokers           = var.victoria_metrics_agent.kafka_brokers
  kafka_topic             = var.victoria_metrics_agent.kafka_topic
  prometheus_enabled      = var.victoria_metrics_agent.prometheus_enabled
  prometheus_url          = var.victoria_metrics_agent.prometheus_url
  logger_level            = var.victoria_metrics_agent.logger_level
  logger_format           = var.victoria_metrics_agent.logger_format
  service_monitor_enabled = var.victoria_metrics_agent.service_monitor_enabled
  resources               = var.victoria_metrics_agent.resources
  affinity                = var.victoria_metrics_agent.affinity
  tolerations             = var.victoria_metrics_agent.tolerations
  node_selector           = var.victoria_metrics_agent.node_selector
  pod_annotations         = var.victoria_metrics_agent.pod_annotations
  extra_env               = var.victoria_metrics_agent.extra_env
  extra_volumes           = var.victoria_metrics_agent.extra_volumes
  extra_volume_mounts     = var.victoria_metrics_agent.extra_volume_mounts
  extra_args              = var.victoria_metrics_agent.extra_args
  extra_values            = var.victoria_metrics_agent.extra_values
}
