resource "kubernetes_namespace" "care_namespace" {
  metadata {
    name = "care-production"
  }
}

resource "kubernetes_config_map" "care_production" {
  metadata {
    name      = "care-production"
    namespace = "care-production"

    labels = {
      app = "care"
      env = "staging"
    }
  }

  data = {
    POSTGRES_DB                = "postgres"
    POSTGRES_USER              = "postgres"
    POSTGRES_HOST              = data.terraform_remote_state.infra.outputs.instance_address
    POSTGRES_PORT              = "5432"
    DJANGO_SECURE_SSL_REDIRECT = "False"
    DJANGO_SETTINGS_MODULE     = "config.settings.staging"
    CSRF_TRUSTED_ORIGINS       = jsonencode(["http://34.93.243.213"])
    DJANGO_ALLOWED_HOSTS       = jsonencode(["34.93.243.213"])
    RATE_LIMIT                 = "5/10m"
    CELERY_BROKER_URL           = "redis://redis:6379/0"
    REDIS_URL                   = "redis://redis:6379/1"
    DJANGO_ADMIN_URL            = "adminurl"
    BUCKET_KEY                  = "2619f726de727d1c6c0c86277389c58f"
    FILE_UPLOAD_BUCKET_ENDPOINT = "https://s3storage.endpoint"
    FACILITY_S3_BUCKET_ENDPOINT = "https://s3storage.endpoint/care-facility-public-bucket"
    FACILITY_S3_STATIC_PREFIX   = "https://s3storage.endpoint/care-facility-public-bucket"
  }
}

# resource "kubernetes_config_map" "nginx_conf" {
#   metadata {
#     name      = "nginx-conf-production"
#     namespace = "care-production"
#   }

#   data = {
#     "nginx.conf" = <<-EOT
#       user nginx;
#       worker_processes  1;
#       error_log  /dev/stdout;
#       events {
#         worker_connections  10240;
#       }
#       http {
#         server {
#           listen 80;
#           server_name _;

#           add_header Access-Control-Allow-Origin "*" always;

#           location /api {
#             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#             proxy_set_header Host $http_host;
#             proxy_redirect off;
#             proxy_pass http://care-django-production:9000;
#           }

#           location / {
#             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#             proxy_set_header Host $http_host;
#             proxy_redirect off;
#             proxy_pass http://care-fe-production;
#           }
#         }
#       }
#     EOT
#   }
# }

resource "kubernetes_config_map" "care_fe_production" {
  metadata {
    name      = "care-fe-production"
    namespace = "care-production"

    labels = {
      app       = "care-fe-production"
      env       = "production"
      namespace = "care-production"
    }
  }

  data = {
    "config.json" = <<-EOT
      {
        "dashboard_url": "https://metabase.demo.example.in",
        "github_url": "https://github.com/coronasafe",
        "coronasafe_url": "https://coronasafe.network?ref=care",
        "site_url": "care.demo.example.in",
        "analytics_server_url": "",
        "header_logo": {
            "light":"https://cdn.coronasafe.network/header_logo.png",
            "dark":"https://cdn.coronasafe.network/header_logo.png"
        },
        "main_logo": {
            "light":"https://cdn.coronasafe.network/10bedicu_logo.png",
            "dark":"https://cdn.coronasafe.network/10bedicu_logo.png"
        },
        "state_logo": {
              "light":"https://cdn.coronasafe.network/10bedicu_logo.png",
              "dark":"https://cdn.coronasafe.network/10bedicu_logo.png"
        },
        "gmaps_api_key": "",
        "gov_data_api_key": "",
        "recaptcha_site_key": "",
        "sentry_dsn": "",
        "sentry_environment": "prod",
        "kasp_enabled": false,
        "kasp_string": "KASP",
        "kasp_full_string": "Karunya Arogya Suraksha Padhathi",
        "sample_format_asset_import": "https://spreadsheets.google.com/feeds/download/spreadsheets/Export?key=11JaEhNHdyCHth4YQs_44YaRlP77Rrqe81VSEfg1glko&exportFormat=xlsx",
        "sample_format_external_result_import": "https://docs.google.com/spreadsheets/d/17VfgryA6OYSYgtQZeXU9mp7kNvLySeEawvnLBO_1nuE/export?format=csv&id=17VfgryA6OYSYgtQZeXU9mp7kNvLySeEawvnLBO_1nuE",
        "enable_abdm": true
      }
    EOT
  }
}


resource "kubernetes_secret" "care_production" {
  metadata {
    name      = "care-production"
    namespace = "care-production"

    labels = {
      app = "care"
      env = "staging"
    }
  }

  data = {
    DJANGO_SECRET_KEY = data.google_secret_manager_secret_version.django_secret_key.secret_data
    POSTGRES_PASSWORD = data.google_secret_manager_secret_version.db_password.secret_data
    DATABASE_URL      = "postgresql://postgres:${data.google_secret_manager_secret_version.db_password.secret_data}@${data.terraform_remote_state.infra.outputs.instance_address}:5432/postgres"
    BUCKET_SECRET               = data.google_secret_manager_secret_version.bucket_secret.secret_data
    JWKS_BASE64                 = data.google_secret_manager_secret_version.jwks_base64.secret_data
    # SENTRY_PROFILES_SAMPLE_RATE = "0.5"
    # SENTRY_TRACES_SAMPLE_RATE   = "0.5"
    # SENTRY_ENVIRONMENT          = "sentry-demo"
    # SENTRY_DSN                  = "yourdsn/1234"
  }
}
