output "role_ids" {
  description = "Map of created Role names to their resource IDs."
  value       = { for k, v in kubernetes_role_v1.this : k => v.id }
}

output "role_names" {
  description = "List of created Role names."
  value       = [for r in kubernetes_role_v1.this : r.metadata[0].name]
}

output "role_binding_ids" {
  description = "Map of created RoleBinding names to their resource IDs."
  value       = { for k, v in kubernetes_role_binding_v1.this : k => v.id }
}

output "role_binding_names" {
  description = "List of created RoleBinding names."
  value       = [for rb in kubernetes_role_binding_v1.this : rb.metadata[0].name]
}

output "cluster_role_ids" {
  description = "Map of created ClusterRole names to their resource IDs."
  value       = { for k, v in kubernetes_cluster_role_v1.this : k => v.id }
}

output "cluster_role_names" {
  description = "List of created ClusterRole names."
  value       = [for cr in kubernetes_cluster_role_v1.this : cr.metadata[0].name]
}

output "cluster_role_binding_ids" {
  description = "Map of created ClusterRoleBinding names to their resource IDs."
  value       = { for k, v in kubernetes_cluster_role_binding_v1.this : k => v.id }
}

output "cluster_role_binding_names" {
  description = "List of created ClusterRoleBinding names."
  value       = [for crb in kubernetes_cluster_role_binding_v1.this : crb.metadata[0].name]
}
