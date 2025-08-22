# Service with BackendConfig Integration
module "care_service" {
  source        = "github.com/terraform-iaac/terraform-kubernetes-service"
  app_name      = module.care_django_deployment.name
  app_namespace = kubernetes_namespace.care_namespace.metadata[0].name
  #type          = "NodePort"

  port_mapping = [{
    name          = "http"
    internal_port = 9000
    external_port = 80
  }]

  custom_labels = var.care_app_label

  annotations = {
    "cloud.google.com/neg"            = jsonencode({ ingress = true })
    "cloud.google.com/backend-config" = jsonencode({ default = "nginx-backend-config" })
  }

  depends_on = [
    kubernetes_manifest.backend_config,
  ]
}

# module "nginx_service" {
#   source        = "github.com/terraform-iaac/terraform-kubernetes-service"
#   app_name      = module.care_nginx.name
#   app_namespace = kubernetes_namespace.care_namespace.metadata[0].name
#   type          = "ClusterIP"

#   port_mapping = [{
#     name          = "http"
#     internal_port = 80
#     external_port = 80
#   }]

#   custom_labels = var.nginx_custom_label
# }

module "frontend_service" {
  source        = "github.com/terraform-iaac/terraform-kubernetes-service"
  app_name      = module.care_frontend.name
  app_namespace = kubernetes_namespace.care_namespace.metadata[0].name

  port_mapping = [{
    name          = "fronted"
    internal_port = 80
    external_port = 80
  }]
}

# Redis Service
module "redis_service" {
  source        = "github.com/terraform-iaac/terraform-kubernetes-service"
  app_name      = "redis"
  app_namespace = kubernetes_namespace.care_namespace.metadata[0].name
  type          = "ClusterIP"

  port_mapping = [{
    name          = "redis"
    internal_port = 6379
    external_port = 6379
  }]

  custom_labels = var.redis_custom_label
}