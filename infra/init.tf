terraform {
  backend "gcs" {
    # configure bucket, prefix, credentials, etc.
    prefix = "infra"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.33.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "6.33.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "google" {
  project = "virtual-sum-463317-h0"
  region  = "asia-south1"
}

provider "google-beta" {
  project = "virtual-sum-463317-h0"
  region  = "asia-south1"
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}
