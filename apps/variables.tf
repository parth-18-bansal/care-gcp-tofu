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

variable "zone" {
  description = "The zone for the GKE cluster."
  type        = string
}

# GKE Cluster
variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
}

# variable "gke_subnets" {
#   description = "Primary IP range for GKE subnet"
#   type        = string
# }

# variable "gke_pods_range" {
#   description = "Secondary IP range for GKE pods"
#   type        = string
# }

# variable "gke_services_range" {
#   description = "Secondary IP range for GKE services"
#   type        = string
# }

# variable "node_pools" {
#   description = "The node pools for the GKE cluster."
#   type = list(object({
#     name         = string
#     machine_type = string
#     min_count    = number
#     max_count    = number
#     preemptible  = bool
#     disk_size_gb = number
#   }))
# }




# Database
# variable "alloydb_cpu_count" {
#   description = "The number of CPUs to allocate for the AlloyDB machine."
#   type        = number
# }

# variable "alloydb_read_pool_size" {
#   type = number
# }

# Care App
variable "care_app_label" {
    description = ""
    default = {
        app = "care-app"
    }
    
}

# Redis 
variable "redis_port" {
  description = "List of ports to expose from the redis container"
    default = [
    {
      name = "redis-port"
      internal_port = "6379"
    }
  ]
}

variable "redis_custom_label" {
    default = {
        app = "redis-cache-production"
    }
}

# Frontend
variable "frontend_port" {
  description = "List of ports to expose from the frontend container"
    default = [
    {
      name = "care-fe-prod"
      internal_port = "80"
    }
  ]
}

variable "frontend_custom_label" {
    default = {
        app = "care-fe-production"
    }
}

variable "frontend_image_pull_policy" {
  type = string
}

# nginx
variable "nginx_custom_label" {
    default = {
        app = "care-nginx-production"
    }
}

variable "nginx_port" {
  description = "List of ports to expose from the nginx container"
    default = [
    {
      name = "nginx-port"
      internal_port = "80"
    }
  ]
}

variable "nginx_app_label" {
    description = ""
    default = {
        app = "care-app"
    }
    
}






