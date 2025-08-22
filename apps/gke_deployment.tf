# Django Application Deployment
module "care_django_deployment" {
  source = "git::https://github.com/tellmeY18/terraform-kubernetes-deployment.git?ref=main"

  name      = "care-django-production"
  namespace = kubernetes_namespace.care_namespace.metadata[0].name
  image     = "ghcr.io/ohcnetwork/care:latest"
  command   = ["/app/start.sh"]
  replicas  = 2

  custom_labels = var.care_app_label

  internal_port = [{
    name          = "django"
    internal_port = 9000
    host_port     = null
  }]

  env_from = [
    {
      config_map_ref = { name = "care-production" }
    },
    {
      secret_ref = { name = "care-production" }
    }
  ]
}

# Celery Beat Deployment
module "care_celery_beat" {
  source = "git::https://github.com/tellmeY18/terraform-kubernetes-deployment.git?ref=main"

  name      = "care-celery-beat"
  namespace = kubernetes_namespace.care_namespace.metadata[0].name
  image     = "ghcr.io/ohcnetwork/care:latest"
  command   = ["/app/celery_beat.sh"]
  replicas  = 1

  env_from = [
    {
      config_map_ref = { name = "care-production" }
    },
    {
      secret_ref = { name = "care-production" }
    }
  ]
}

# Celery Worker Deployment
module "care_celery_worker" {
  source = "git::https://github.com/tellmeY18/terraform-kubernetes-deployment.git?ref=main"

  name      = "care-celery-worker"
  namespace = kubernetes_namespace.care_namespace.metadata[0].name
  image     = "ghcr.io/ohcnetwork/care:latest"
  command   = ["/app/celery_worker.sh"]
  replicas  = 1

  env_from = [
    {
      config_map_ref = { name = "care-production" }
    },
    {
      secret_ref = { name = "care-production" }
    }
  ]
}

module "care_redis" {
  source = "git::https://github.com/tellmeY18/terraform-kubernetes-deployment.git?ref=main"

  name      = "redis"
  namespace = kubernetes_namespace.care_namespace.metadata[0].name
  custom_labels = var.redis_custom_label
  image     = "redis/redis-stack-server:6.2.6-v10"
  replicas  = 1
  internal_port = var.redis_port
}

module "care_frontend" {
  source = "git::https://github.com/tellmeY18/terraform-kubernetes-deployment.git?ref=main"

  name      = "care-fe-production"
  namespace = kubernetes_namespace.care_namespace.metadata[0].name
  custom_labels = var.frontend_custom_label
  image     = "ghcr.io/ohcnetwork/care_fe:latest"
  internal_port = var.frontend_port
  image_pull_policy = var.frontend_image_pull_policy

  replicas          = 1

  # volumes from config map
  volume_config_map = [
    {
      volume_name = "care-fe-production"
      name        = "care-fe-production"
      mode        = null 
      items = [
        {
          key  = "config.json"
          path = "config.json"
        }
      ]
    }
  ]

  # volume mount inside the container
  volume_mount = [
    {
      volume_name = "care-fe-production"
      mount_path  = "/usr/share/nginx/html/config.json"
      sub_path    = "config.json"
      read_only   = true
    }
  ]
}

# module "care_nginx" {
#   source = "git::https://github.com/tellmeY18/terraform-kubernetes-deployment.git?ref=main"

#   name      = "care-nginx-production"
#   namespace = kubernetes_namespace.care_namespace.metadata[0].name
#   custom_labels = var.nginx_custom_label
#   image     = "nginx:1.21"
#   internal_port = var.nginx_port

#   replicas          = 1

#   # volumes from config map
#   volume_config_map = [
#     {
#       volume_name = "nginx-conf-production"
#       name        = "nginx-conf-production"
#       mode        = null 
#       items = [
#         {
#           key  = "nginx.conf"
#           path = "nginx.conf"
#         }
#       ]
#     }
#   ]

#   # volume mount inside the container
#   volume_mount = [
#     {
#       volume_name = "nginx-conf-production"
#       mount_path  = "/etc/nginx/nginx.conf"
#       sub_path    = "nginx.conf"
#     }
#   ]

#   depends_on = [
#     module.care_service
#   ]
# }



