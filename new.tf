    provider "google" {
  credentials = file("account.json")
  project     = var.project
  region      = var.region

}


resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "project_log"
  project                     = var.project 
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "US"
  default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }
   role          = "OWNER"
    user_by_email = google_service_account.bqowner.email
  }
  access {
    role   = "READER"
    domain = "hashicorp.com"
  }
}
resource "google_service_account" "bqowner" {
  account_id = "bqowner"
}
resource "google_project_service" "enable_destination_api" {
  project     = var.project
  service     = "bigquery.googleapis.com"
  disable_on_destroy = false
}
resource "google_logging_project_sink" "projectsinks" {
    name = "projectsinks"
    destination= "bigquery.googleapis.com/projects/${var.project}/datasets/${google_bigquery_dataset.dataset.datase
t_id}"
    project = google_project_service.enable_destination_api.project
    filter = "resource.type = project"
    unique_writer_identity = true
 }
resource "google_project_iam_binding" "log-writer-storage" {
  role = "roles/storage.objectCreator"
  members = [
    google_logging_project_sink.projectsinks.writer_identity,
  ]
}
resource "google_project_iam_binding" "log-writer-bigquery" {
  role = "roles/bigquery.dataEditor"
  members = [
    google_logging_project_sink.projectsinks.writer_identity,
  ]
}
