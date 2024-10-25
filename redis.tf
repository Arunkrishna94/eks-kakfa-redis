resource "helm_release" "redis" {
  name       = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"

  set {
    name  = "global.storageClass"
    value = "efs-sc"
  }
  set {
    name  = "master.persistence.size"
    value = "5Gi"
  }
}
