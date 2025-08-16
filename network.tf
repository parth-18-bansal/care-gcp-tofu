resource "google_compute_global_address" "care_pip" {
  name = "care-pip"
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 11.0"

  project_id   = var.project_id
  network_name = "ohn-${var.environment}"

  subnets = [
    {
      subnet_name        = "database"
      subnet_ip          = local.database_subnets
      subnet_region      = var.region
    },
    {
      subnet_name        = "gke"
      subnet_ip          = var.gke_subnets
      subnet_region      = var.region
    }
  ]

  secondary_ranges = {
    gke = [
      {
        range_name    = "gke-pods-range"
        ip_cidr_range = var.gke_pods_range
      },
      {
        range_name    = "gke-services-range"
        ip_cidr_range = var.gke_services_range
      }
    ]
  }
  routes = []
}

# GKE Pod and Service IP ranges for VPC-native cluster
resource "google_compute_global_address" "pods_range" {
  name          = "gke-pods-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc.network_self_link
}

resource "google_compute_global_address" "services_range" {
  name          = "gke-services-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = module.vpc.network_self_link
}

#### 4. Outputs for Downstream Modules
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.network_id
}

output "database_subnets" {
  description = "List of database subnet self-links"
  value       = module.vpc.subnets_self_links
}

