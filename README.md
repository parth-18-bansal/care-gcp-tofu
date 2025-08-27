## 1. Setup the Tofu Service Account
     First create a service account for the tofu manually through the console and attach these role to it.
          a) Compute Network Admin
          b) Editor
          c) Kubernetes Engine Admin
          d) Kubernetes Engine Cluster Admin
          e) Project IAM Admin
          d) Secret Manager Secret Accessor

Retrieve the Service Account Key from Google Cloud Platform (GCP), store it securely, and set its file path as the value of the GOOGLE_APPLICATION_CREDENTIALS environment variable:
```bash 
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/service-account-key.json"
```

## 2. Install the tofu
Next, install OpenTofu, a tool for managing infrastructure as code. To do this, visit the official OpenTofu installation page and follow the instructions for your operating system: [OpenTofu Installation Guide](https://opentofu.org/docs/intro/install/).

## 3. Setup the GCS
After installing OpenTofu, manually create a Google Cloud Storage (GCS) bucket.

## 4. Run the Make command
During the execution of make all, provide the name of the bucket when prompted
```bash 
   make all
```

Few more changes are left
