variable "repository" {
  type    = string
  default = "headlamp"
}

variable "helm" {
  type = object({
    repository = string
    version    = string
  })
}
