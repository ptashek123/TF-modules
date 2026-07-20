resource "kubernetes_manifest" "gwapi" {
  for_each = fileset("${path.module}/manifests/${local.compare_list[var.cilium_version]}", "*.yaml")
  manifest = yamldecode(file("${path.module}/manifests/${local.compare_list[var.cilium_version]}/${each.value}.yaml"))
}