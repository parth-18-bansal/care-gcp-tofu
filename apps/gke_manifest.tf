resource "kubernetes_manifest" "backend_config" {
  manifest = {
    apiVersion = "cloud.google.com/v1"
    kind       = "BackendConfig"
    metadata = {
      name      = "nginx-backend-config"
      namespace = kubernetes_namespace.care_namespace.metadata[0].name
    }
    spec = {
      timeoutSec = 60
      connectionDraining = {
        drainingTimeoutSec = 60
      }
      healthCheck = {
        checkIntervalSec = 30
        port             = 9000
        type             = "HTTP"
        requestPath      = "/health/"
      }
    }
  }
}