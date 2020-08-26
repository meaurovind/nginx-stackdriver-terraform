provider "google" {
  credentials = file("account.json")
  project     = var.project
  region      = var.region
}

resource "google_bigquery_dataset" "default" {
  dataset_id  = "CIM_logs"
  description = "NGINX Access Logs"
  location    = "US"
}

resource "google_logging_project_sink" "default" {
  name                   = "CISink-logs"
  destination            = "bigquery.googleapis.com/projects/${var.project}/datasets/${google_bigquery_dataset.default.dataset_id}"
  filter                 = "resource.type = gce_instance AND logName = projects/${var.project}/logs/brew-access"
  unique_writer_identity = true
}

resource "google_project_iam_binding" "default" {
  role = "roles/bigquery.dataEditor"

  members = [
    google_logging_project_sink.default.writer_identity,
  ]
}
