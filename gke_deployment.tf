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

  depends_on = [module.gke_cluster]
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

  depends_on = [module.gke_cluster]
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

  depends_on = [module.gke_cluster]
}

module "care_redis" {
  source = "git::https://github.com/tellmeY18/terraform-kubernetes-deployment.git?ref=main"

  name      = "redis"
  namespace = kubernetes_namespace.care_namespace.metadata[0].name
  custom_labels = var.redis_custom_label
  image     = "redis/redis-stack-server:6.2.6-v10"
  replicas  = 1
  internal_port = var.redis_port

  depends_on = [module.gke_cluster]
}



