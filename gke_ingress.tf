# # Ingress Configuration
# resource "kubernetes_ingress_v1" "nginx_ingress" {
#   metadata {
#     name      = "nginx-ingress"
#     namespace = kubernetes_namespace.care_namespace.metadata[0].name
#     annotations = {
#       "kubernetes.io/ingress.class"                 = "gce"
#       "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.care_pip.name
#       #"networking.gke.io/managed-certificates"      = kubernetes_manifest.managed_cert.manifest.metadata.name
#       #"networking.gke.io/v1beta1.FrontendConfig"    = kubernetes_manifest.frontend_config.manifest.metadata.name
#       #"kubernetes.io/ingress.allow-http"            = "false"
#       "kubernetes.io/ingress.allow-http"            = "true"
#     }
#   }

#   spec {
#     rule {
#       #host = var.domain_name
#       http {
#         path {
#           path      = "/*"
#           path_type = "ImplementationSpecific"
#           backend {
#             service {
#               name = module.care_service.name
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }

#   depends_on = [
#     #kubernetes_manifest.managed_cert,
#     module.care_service,
#     #kubernetes_manifest.frontend_config,
#   ]
# }