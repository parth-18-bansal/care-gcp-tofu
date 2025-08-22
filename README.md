1) Create a Service Account for the Tofu. And attach these role to it.
     a) Compute Network Admin
     b) Editor
     c) Kubernetes Engine Admin
     d) Kubernetes Engine Cluster Admin
     e) Project IAM Admin
     d) Secret Manager Secret Accessor
     f) Service Networking Admin (Beta)

3) Retrieve the Service Account Key from Google Cloud Platform (GCP), store it securely, and set its file path as the value of the GOOGLE_APPLICATION_CREDENTIALS environment variable:
   
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/service-account-key.json"

3) After installing OpenTofu, manually create a Google Cloud Storage (GCS) bucket. During the execution of make init, provide the name of the bucket when prompted:
