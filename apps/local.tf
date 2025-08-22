locals {
  required_tags = {
    terraform   = "true"
    environment = var.environment
    project     = "care"
  }

  tags                 = local.required_tags
  image                = "ghcr.io/ohcnetwork/care:latest-475"

  # database
  # database_subnets     = "10.0.1.0/24"

  # GKE
  # gke_subnets          = var.gke_subnets
  # gke_pods_range       = var.gke_pods_range
  # gke_services_range   = var.gke_services_range

  # service account
  # writer_sa_email      = module.service_accounts.email

  # # GCS
  # patient_bucket_name  = "ohn-${var.environment}-${var.app}-patient"
  # facility_bucket_name = "ohn-${var.environment}-${var.app}-facility"

  # secrets
  # secrets = {
  #   POSTGRES_PASSWORD           = random_password.database_master.result
  #   DATABASE_URL                = "postgresql://postgres:${random_password.database_master.result}@${module.alloydb.primary_instance.ip_address}:5432/postgres"
  #   DJANGO_SECRET_KEY           = "itsveryinsecuretokeepthislikethis"
  #   #SENTRY_PROFILES_SAMPLE_RATE = "0.5"
  #   #SENTRY_TRACES_SAMPLE_RATE   = "0.5"
  #   #SENTRY_ENVIRONMENT          = "sentry-demo"
  #   #SENTRY_DSN                  = "yourdsn/1234"
  #   BUCKET_SECRET               = "bucket-secret"
  #   JWKS_BASE64                 = "eyJrZXlzIjogW119"
  # }
}
