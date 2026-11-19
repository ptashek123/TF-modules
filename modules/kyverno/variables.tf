variable "registry" {
  type = string
}

variable "helm" {
  type = object({
    repository = string
    version    = string
  })
}
