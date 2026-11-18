variable "helm" {
  type = object({
    repository = string
    version    = string
  })
}

variable "secret" {
  type = object({
    access_key = string
    secret_key = string
    endpoint   = string
    region     = string
    insecure   = string
  })
  sensitive   = true
  description = "Secrets for connect"
}
variable "images" {
  type = object({
    registrar   = string
    provisioner = string
    csi         = string
  })
  sensitive   = false
  description = "CSI Images"
}
variable "bucket" {
  type = string
}
