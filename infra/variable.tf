variable "region" {
    description = "Region of the Infra"
    type = string
}

variable "environment" {
    description = "environment like dev, uat, prod"
    type = string
}

variable "app" {
    description = ""
    type = string
}

variable "project_id" {
    description = ""
    type = string
}

# GKE Cluster
variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
}

variable "gke_subnets" {
  description = "Primary IP range for GKE subnet"
  type        = string
}

variable "gke_pods_range" {
  description = "Secondary IP range for GKE pods"
  type        = string
}

variable "gke_services_range" {
  description = "Secondary IP range for GKE services"
  type        = string
}

variable "node_pools" {
  description = "The node pools for the GKE cluster."
  type = list(object({
    name         = string
    machine_type = string
    min_count    = number
    max_count    = number
    preemptible  = bool
    disk_size_gb = number
  }))
}

variable "zone" {
  description = "The zone for the GKE cluster."
  type        = string
}

# Database
variable "alloydb_cpu_count" {
  description = "The number of CPUs to allocate for the AlloyDB machine."
  type        = number
}