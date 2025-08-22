# terraform GKE cluster 
data "google_container_cluster" "primary" {
  name     = module.gke_cluster.name
  location = module.gke_cluster.location
  project  = var.project_id
}

data "google_client_config" "default" {}