provider "google" {
  credentials = file("account.json") 
  client_id = "1091869076154-er3uo2763i0pm05uipb8abf2h616877g.apps.googleusercontent.com"
  project     = var.project
  region      = var.region
}

resource "google_bigquery_dataset" "default" {
  dataset_id  = "CIML_logs"
  description = "NGINX Access Logs"
  location    = "US"
}

resource "google_logging_project_sink" "default" {
  name                   = "CISinkl-logs"
  destination            = "bigquery.googleapis.com/projects/${var.project}/datasets/${google_bigquery_dataset.default.dataset_id}"
  filter                 = "resource.type = gce_instance AND logName = projects/${var.project}/logs/brewsim-access"
  
}

resource "google_project_iam_binding" "default" {
  role = "roles/bigquery.dataEditor"

  members = [
    google_logging_project_sink.default.writer_identity,
  ]
}
