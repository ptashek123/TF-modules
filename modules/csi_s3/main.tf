resource "helm_release" "csis3" {
  name            = "csis3"
  chart           = "csi-s3"
  repository      = var.helm.repository
  version         = var.helm.version
  namespace       = "kube-system"
  atomic          = true
  force_update    = false
  reuse_values    = true
  cleanup_on_fail = true
  values = concat([templatefile("${path.module}/values/csis3.yaml", {
    registrar_image   = var.images.registrar
    provisioner_image = var.images.provisioner
    csi_image         = var.images.csi
    bucket            = var.bucket
    })], [templatefile("${path.module}/templates/secret.yaml", {
    access_key = var.secret.access_key
    secret_key = var.secret.secret_key
    endpoint   = var.secret.endpoint
    insecure   = var.secret.insecure
    region     = var.secret.region
  })])
}
