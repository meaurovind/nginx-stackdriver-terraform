provider "google" {
  
  access_token = "ya29.a0AfH6SMCCFXKM3ZUrQffjJdqdWJWh6m560mTMsTjyx84nWj10DCQcyVcZfl6Yqcsq2OCMZb9QBPVTC9U65GKFknm41SUod-S_0wwRkdpW1vi0FZce7LJsKQ0RSpa3sMRTiKP4ZFNPGXcoNiQmEsMtESlGWc3AFaOgh6QAeGZzZAEy9rWeHiBxkcCYhnpTqu6HZIbrz5Pev1PDadNtK9C9ElkW1p-LQJU-Cy0GT_x2osworxCAIPPPqSaaRUtfmHDbXTQCPf0l8PG58g"
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
