variable "roles" {
  description = "A map of Kubernetes Role definitions. Each key is the role name, value is an object with role properties."
  type = map(object({
    namespace = optional(string, "default")
    rules = list(object({
      api_groups     = optional(list(string), [""])
      resources      = list(string)
      verbs          = list(string)
      resource_names = optional(list(string), [])
    }))
    annotations = optional(map(string), {})
    labels      = optional(map(string), {})
  }))
  default = {}
}

variable "role_bindings" {
  description = "A map of Kubernetes RoleBinding definitions. Each key is the binding name, value is an object with binding properties."
  type = map(object({
    namespace = optional(string, "default")
    role_ref = object({
      api_group = optional(string, "rbac.authorization.k8s.io")
      kind      = string
      name      = string
    })
    subjects = list(object({
      kind      = string
      name      = string
      namespace = optional(string, "")
      api_group = optional(string, "rbac.authorization.k8s.io")
    }))
    annotations = optional(map(string), {})
    labels      = optional(map(string), {})
  }))
  default = {}
}

variable "cluster_roles" {
  description = "A map of Kubernetes ClusterRole definitions. Each key is the cluster role name, value is an object with cluster role properties."
  type = map(object({
    rules = list(object({
      api_groups        = optional(list(string), [""])
      resources         = list(string)
      verbs             = list(string)
      resource_names    = optional(list(string), [])
      non_resource_urls = optional(list(string), [])
    }))
    annotations = optional(map(string), {})
    labels      = optional(map(string), {})
  }))
  default = {}
}

variable "cluster_role_bindings" {
  description = "A map of Kubernetes ClusterRoleBinding definitions. Each key is the binding name, value is an object with binding properties."
  type = map(object({
    role_ref = object({
      api_group = optional(string, "rbac.authorization.k8s.io")
      kind      = string
      name      = string
    })
    subjects = list(object({
      kind      = string
      name      = string
      namespace = optional(string, "")
      api_group = optional(string, "rbac.authorization.k8s.io")
    }))
    annotations = optional(map(string), {})
    labels      = optional(map(string), {})
  }))
  default = {}
}
