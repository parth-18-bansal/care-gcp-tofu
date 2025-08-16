# Service with BackendConfig Integration
# module "care_service" {
#   source        = "terraform-iaac/service/kubernetes"
#   app_name      = module.care_django_deployment.name
#   app_namespace = kubernetes_namespace.care_namespace.metadata[0].name
#   type          = "NodePort"

#   port_mapping = [{
#     name          = "http"
#     internal_port = 9000
#     external_port = 80
#   }]

#   custom_labels = var.care_app_label

#   annotations = {
#     "cloud.google.com/neg"            = jsonencode({ ingress = true })
#     "cloud.google.com/backend-config" = jsonencode({ default = "nginx-backend-config" })
#   }

#   depends_on = [
#     kubernetes_manifest.backend_config,
#     module.gke_cluster
#   ]
# }

# Redis Service
module "care_service" {
  source        = "terraform-iaac/service/kubernetes"
  app_name      = "redis"
  app_namespace = kubernetes_namespace.care_namespace.metadata[0].name
  type          = "ClusterIP"

  port_mapping = [{
    name          = "redis"
    internal_port = 6379
    external_port = 6379
  }]

  custom_labels = var.redis_custom_label

  depends_on = [
    module.gke_cluster
  ]
}


# # Redis service
# resource "kubernetes_service" "redis_service" {
#   metadata {
#     name        = "redis"
#     namespace   = kubernetes_namespace.care_namespace.metadata[0].name
#     labels      = var.redis_custom_label
#   }
#   spec {
#     selector                    = var.redis_custom_label
#     type                        = "ClusterIP"
#     port {
#       port = var.redis_port[0].internal_port
#       target_port = var.redis_port[0].internal_port
#       protocol = "TCP"
#     }
#   }
# }