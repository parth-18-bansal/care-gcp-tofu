# service accounts are used to give the access of google cloud resources to resource or non-human thing. Here we first create the service account
# then attach the iam roles, then attach that service account to the resource.
module "service_accounts" {
  source       = "terraform-google-modules/service-accounts/google"
  version      = "~> 4.5.3"
  project_id   = var.project_id
  names        = ["ohn-${var.environment}-${var.app}-writer"]
  display_name = "Bucket Writer Service Account"
  descriptions = ["Service Account for writing to buckets"]
}

#we are giving the service account the permission to act as admin to the bucket. service account get permission to be admin to the bucket.
resource "google_storage_bucket_iam_member" "patient_bucket_admin" {
  bucket = module.patient_bucket.name # permission of which resource 
  role   = "roles/storage.admin" # what is the permission
  member = "serviceAccount:${local.writer_sa_email}" # whom get the permission

  depends_on = [module.patient_bucket]
}

resource "google_storage_bucket_iam_member" "facility_bucket_admin" {
  bucket = module.facility_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${local.writer_sa_email}"

  depends_on = [module.facility_bucket]
}

resource "google_storage_bucket_iam_member" "public_facility" {
  bucket = module.facility_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"

  depends_on = [module.facility_bucket]
}