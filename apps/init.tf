terraform {
  backend "gcs" {
    # configure bucket, prefix, credentials, etc.
    prefix = "apps"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.45.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "6.45.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source = "hashicorp/helm"
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

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

