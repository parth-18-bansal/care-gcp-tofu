# Django Key
resource "google_secret_manager_secret" "django_secret_key" {
  secret_id  = "django-secret-key"
  replication {
    user_managed {
        replicas {
            location = var.region
        }
    }
 }
}

resource "google_secret_manager_secret_version" "django_secret_key_version" {
  secret      = google_secret_manager_secret.django_secret_key.id
  secret_data = "super-secret-key"
}

# db password
resource "google_secret_manager_secret" "db_password" {
  secret_id  = "db-password"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.database_master.result
}

# bucket secret
resource "google_secret_manager_secret" "bucket_secret" {
  secret_id  = "bucket-secret"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "bucket_secret_version" {
  secret      = google_secret_manager_secret.bucket_secret.id
  secret_data = "bucket-secret"
}

# JWKS_BASE64
resource "google_secret_manager_secret" "jwks_base64" {
  secret_id  = "jwks-base64"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "jwks_base64_version" {
  secret      = google_secret_manager_secret.jwks_base64.id
  secret_data = "eyJrZXlzIjogW119"
}
