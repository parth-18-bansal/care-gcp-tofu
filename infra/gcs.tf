# browser don't allow the web page to make the request to other origin.
# it first send the preflight request to that origin, and if that origin say yes,
# then it allow the web page to send the request to that other origin.

# so here browser --> preflight request to the cdn, then cdn say yes
# the original request ---> go to the cdn.
# then cdn check it cache or sent the request to the bucket.
module "patient_bucket" {
  source     = "terraform-google-modules/cloud-storage/google"
  version    = "~> 10.0"
  project_id = var.project_id
  location   = var.region
  names      = [local.patient_bucket_name]
  bucket_policy_only = {
    "${local.patient_bucket_name}" = true
  }
#   cors = [
#     {
#       origin          = ["https://${var.cdn_domain_name}"]
#       method          = ["GET", "PUT", "POST"]
#       response_header = ["*"]
#       max_age_seconds = 3000
#     }
#   ]

  depends_on = [module.service_accounts]
}

module "facility_bucket" {
  source     = "terraform-google-modules/cloud-storage/google"
  version    = "~> 10.0"
  project_id = var.project_id
  location   = var.region
  names      = [local.facility_bucket_name]
  bucket_policy_only = {
    "${local.facility_bucket_name}" = true
  }
#   cors = [
#     {
#       origin          = ["https://${var.cdn_domain_name}"]
#       method          = ["GET", "PUT", "POST"]
#       response_header = ["*"]
#       max_age_seconds = 3000
#     }
#   ]

  depends_on = [module.service_accounts]
}

output "writer_service_account_email" {
  description = "The email of the service account used for bucket operations"
  value       = local.writer_sa_email
}

output "patient_bucket_name" {
  description = "The name of the patient bucket"
  value       = module.patient_bucket.name
}

output "facility_bucket_name" {
  description = "The name of the facility bucket"
  value       = module.facility_bucket.name
}
