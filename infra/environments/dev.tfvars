project_id="virtual-sum-463317-h0"
app="care"
environment="dev"
region="asia-south1"


# GKE Cluster
cluster_name="care-gke"
zone="asia-south1-a"
gke_subnets="10.0.4.0/22"
gke_pods_range="10.12.0.0/14"
gke_services_range="10.8.0.0/20"
node_pools = [
  {
    name         = "pool-1"
    machine_type = "e2-standard-2"
    min_count    = 2
    max_count    = 2
    preemptible  = false
    disk_size_gb = 100
  },
]

# Database
alloydb_cpu_count=2