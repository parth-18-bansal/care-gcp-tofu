locals {
  required_tags = {
    terraform   = "true"
    environment = var.environment
    project     = "care"
  }

  tags                 = local.required_tags
  image                = "ghcr.io/ohcnetwork/care:latest-475"

  # GKE
  gke_subnets          = var.gke_subnets
  gke_pods_range       = var.gke_pods_range
  gke_services_range   = var.gke_services_range

  # networks
  database_subnets     = "10.0.1.0/24"

  # GCS
  patient_bucket_name  = "ohn-${var.environment}-${var.app}-patient"
  facility_bucket_name = "ohn-${var.environment}-${var.app}-facility"

  # service account
  writer_sa_email      = module.service_accounts.email
}
