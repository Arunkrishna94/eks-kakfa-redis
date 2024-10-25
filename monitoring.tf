resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"

  set {
    name  = "server.persistentVolume.size"
    value = "10Gi"
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"

  set {
    name  = "persistence.size"
    value = "10Gi"
  }
}
