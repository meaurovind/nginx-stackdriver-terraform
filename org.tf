 provider "google" {
  credentials = file("account.json")
  organization_id = var.organization.id
  project     = var.project
  

}


resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "org_loggings"
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
resource "google_organization_policy" "services_policy" {
  org_id     = "142352932669"
  constraint = "serviceuser.services"

  restore_policy {
    default = true
  }
}
resource "google_project_service" "enable_destination_api" {
  project     = var.project
  service     = "bigquery.googleapis.com"
  disable_on_destroy = false
}
#resource "google_logging_project_sink" "projectsink" {
    #name = "projectsink"
   # destination = "bigquery.googleapis.com/projects/${var.project}/datasets/${google_bigquery_dataset.dataset.dataset_id}"
   # project = google_project_service.enable_destination_api.project
   # filter = "resource.type = project AND logName = projects/${var.project}/new_logs"
   # unique_writer_identity = true
# }

resource "google_logging_organization_sink" "org-sink" {
  name   = "org-sink"
  org_id = "142352932669"
  destination = "bigquery.googleapis.com/datasets/${google_bigquery_dataset.dataset.dataset_id}"
  project = google_project_service.enable_destination_api.project
  filter = "resource.type = project AND severity >= WARN"
}

resource "google_storage_bucket" "log-bucket" {
  name = "organization-logging-bucket"
}

resource "google_project_iam_member" "log-writer" {
  role = "roles/storage.objectCreator"

  member = google_logging_organization_sink.org-sink.writer_identity
}


resource "google_project_iam_binding" "log-writer-bigquery" {
  role = "roles/bigquery.dataEditor"
  members = [
    google_logging_project_sink.projectsink.writer_identity,
  ]
}

resource "google_project_iam_member" "log-writer" {
  role = "roles/storage.objectCreator"

  member = google_logging_organization_sink.org-sink.writer_identity
}
