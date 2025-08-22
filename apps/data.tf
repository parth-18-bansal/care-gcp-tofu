# django secret key
data "google_secret_manager_secret_version" "django_secret_key" {
  secret = "django-secret-key"
}

# db password
data "google_secret_manager_secret_version" "db_password" {
  secret = "db-password"
}

# bucket secret
data "google_secret_manager_secret_version" "bucket_secret" {
  secret = "bucket-secret"
}

# jwks_base64
data "google_secret_manager_secret_version" "jwks_base64" {
  secret = "jwks-base64"
}

# terrform remote state of infra folder
data "terraform_remote_state" "infra" {
  backend = "gcs"
  config = {
    bucket = "demo-care-tofu"
    prefix = "infra"
  }
}

# terraform GKE cluster 
data "google_container_cluster" "primary" {
  name     = data.terraform_remote_state.infra.outputs.cluster_name
  location = data.terraform_remote_state.infra.outputs.cluster_location
  project  = data.terraform_remote_state.infra.outputs.project_id
}

data "google_client_config" "default" {}