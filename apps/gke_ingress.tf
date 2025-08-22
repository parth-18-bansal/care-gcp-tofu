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
#               name = module.care_service_app.name
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
#     module.care_service_app,
#     #kubernetes_manifest.frontend_config,
#   ]
# }


#######################################################################################################

# resource "kubernetes_ingress_v1" "care_ingress" {
#   metadata {
#     name      = "care-ingress"
#     namespace = "default"

#     annotations = {
#       "kubernetes.io/ingress.class"              = "nginx"
#       "ingress.kubernetes.io/ssl-redirect"       = "true"
#       "cert-manager.io/cluster-issuer"           = "letsencrypt-production"
#     }
#   }

#   spec {
#     tls {
#       hosts       = [
#         "care.demo.example.in",
#         "careapi.demo.example.in",
#         "metabase.demo.example.in",
#       ]
#       secret_name = "care-tls"
#     }

#     rule {
#       host = "care.demo.example.in"
#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = "care-nginx-production"
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }

#     rule {
#       host = "careapi.demo.example.in"
#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = "care-nginx-production"
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }

#     rule {
#       host = "metabase.demo.example.in"
#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = "care-nginx-production"
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"

  cleanup_on_fail = true

  create_namespace = true

  set {
      name = "controller.service.loadBalancerIP"
      value = data.terraform_remote_state.infra.outputs.care_pip_address
  }
}



resource "kubernetes_ingress_v1" "care_ingress" {
  metadata {
    name      = "care-ingress"
    namespace = kubernetes_namespace.care_namespace.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = false
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10m"
      "nginx.ingress.kubernetes.io/cors-allow-origin"  = "*"
      "nginx.ingress.kubernetes.io/cors-allow-methods" = "GET, POST, PUT, DELETE, OPTIONS"
      "nginx.ingress.kubernetes.io/cors-allow-headers" = "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range"
      "nginx.ingress.kubernetes.io/cors-expose-headers" = "Content-Length,Content-Range"
    }
  }

  spec {
    ingress_class_name = "nginx"
    rule {
      #host = "care.demo.example.in"
      http {
        path {
          path = "/api"
          path_type = "Prefix"
          backend {
            service {
              name = "care-django-production"
              port { number = 9000 }
            }
          }
        }
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "care-fe-production"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
