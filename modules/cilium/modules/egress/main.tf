resource "kubernetes_node_taint" "egress" {
  for_each = toset(var.nodes)
  metadata {
    name = each.key
  }
  force = true
  taint {
    key    = "egress/deploy"
    value  = "true"
    effect = "NoSchedule"
  }
}