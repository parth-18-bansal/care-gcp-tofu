
resource "random_password" "database_master" {
  length           = 20
  special          = true
  override_special = "_%@!" # Example special characters
}


resource "google_compute_global_address" "alloydb_peering_range" {
  name          = "alloydb-peering-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc.network_self_link
}

resource "google_service_networking_connection" "alloydb_psa" {
  network                 = module.vpc.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.alloydb_peering_range.name]
}


module "alloydb" {
  source  = "GoogleCloudPlatform/alloy-db/google"
  version = "~> 4.0"

  # Core cluster settings
  project_id       = var.project_id
  cluster_id       = "${var.app}-${var.environment}"
  cluster_location = var.region
  cluster_labels   = local.tags
  cluster_initial_user = {
    user     = "postgres"
    password = random_password.database_master.result
  }
  network_self_link = "projects/${var.project_id}/global/networks/${module.vpc.network_name}"


  # Engine version & encryption
  database_version = "POSTGRES_15"

  # Primary instance configuration
  primary_instance = {
    instance_id        = "${var.app}-${var.environment}-primary"
    display_name       = "${var.app}-${var.environment}-primary"
    machine_cpu_count  = var.alloydb_cpu_count
    ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    require_connectors = false
    enable_public_ip   = false
    query_insights_config = {
      query_plans_per_minute  = 5
      query_string_length     = 1024
      record_application_tags = true
      record_client_address   = true
    }
    depends_on = [
      google_service_networking_connection.alloydb_psa

    ]
  }
}

output "instance_arn" {
  description = "ID of the AlloyDB cluster"
  value       = module.alloydb.cluster_id
}

output "instance_address" {
  description = "IP address of the primary instance"
  value       = module.alloydb.primary_instance.ip_address
}

output "primary_connection_string" {
  description = "Connection string for the primary instance"
  value       = "postgresql://postgres:${random_password.database_master.result}@${module.alloydb.primary_instance.ip_address}:5432"
  sensitive   = true
}
