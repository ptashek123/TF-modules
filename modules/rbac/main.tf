resource "kubernetes_role_v1" "this" {
  for_each = var.roles

  metadata {
    name        = each.key
    namespace   = each.value.namespace
    annotations = each.value.annotations
    labels      = each.value.labels
  }

  dynamic "rule" {
    for_each = each.value.rules

    content {
      api_groups     = rule.value.api_groups
      resources      = rule.value.resources
      verbs          = rule.value.verbs
      resource_names = rule.value.resource_names
    }
  }
}

resource "kubernetes_role_binding_v1" "this" {
  for_each = var.role_bindings

  metadata {
    name        = each.key
    namespace   = each.value.namespace
    annotations = each.value.annotations
    labels      = each.value.labels
  }

  role_ref {
    api_group = each.value.role_ref.api_group
    kind      = each.value.role_ref.kind
    name      = each.value.role_ref.name
  }

  dynamic "subject" {
    for_each = each.value.subjects

    content {
      kind      = subject.value.kind
      name      = subject.value.name
      namespace = subject.value.namespace
      api_group = subject.value.api_group
    }
  }
}

resource "kubernetes_cluster_role_v1" "this" {
  for_each = var.cluster_roles

  metadata {
    name        = each.key
    annotations = each.value.annotations
    labels      = each.value.labels
  }

  dynamic "rule" {
    for_each = each.value.rules

    content {
      api_groups        = rule.value.api_groups
      resources         = rule.value.resources
      verbs             = rule.value.verbs
      resource_names    = rule.value.resource_names
      non_resource_urls = rule.value.non_resource_urls
    }
  }
}

resource "kubernetes_cluster_role_binding_v1" "this" {
  for_each = var.cluster_role_bindings

  metadata {
    name        = each.key
    annotations = each.value.annotations
    labels      = each.value.labels
  }

  role_ref {
    api_group = each.value.role_ref.api_group
    kind      = each.value.role_ref.kind
    name      = each.value.role_ref.name
  }

  dynamic "subject" {
    for_each = each.value.subjects

    content {
      kind      = subject.value.kind
      name      = subject.value.name
      namespace = subject.value.namespace
      api_group = subject.value.api_group
    }
  }
}
