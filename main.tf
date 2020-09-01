 provider "google" {
  credentials = file("account.json")
  project     = var.project
  region      = var.region

}


resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "project_loggings"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "US"
  default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }

  access {
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
resource "google_logging_project_sink" "projectsink" {
    name = "projectsink"
    destination= "bigquery.googleapis.com/projects/${var.project}/datasets/instance-activity"
    project = google_project_service.enable_destination_api.project
    filter = "resource.type = project"
    unique_writer_identity = true
