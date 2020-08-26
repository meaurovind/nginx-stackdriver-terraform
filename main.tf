provider "google" {
  
  access_token = "ya29.a0AfH6SMCCFXKM3ZUrQffjJdqdWJWh6m560mTMsTjyx84nWj10DCQcyVcZfl6Yqcsq2OCMZb9QBPVTC9U65GKFknm41SUod-S_0wwRkdpW1vi0FZce7LJsKQ0RSpa3sMRTiKP4ZFNPGXcoNiQmEsMtESlGWc3AFaOgh6QAeGZzZAEy9rWeHiBxkcCYhnpTqu6HZIbrz5Pev1PDadNtK9C9ElkW1p-LQJU-Cy0GT_x2osworxCAIPPPqSaaRUtfmHDbXTQCPf0l8PG58g"
  project     = var.project
  region      = var.region
}

project = "${google_project.project.project_id}"
filter = "resource.type = project" AND logName = projects/${var.project}/logs/nginx-access"
  
}

resource "google_project_iam_binding" "default" {
  role = "roles/bigquery.dataEditor"

  members = [
    google_logging_project_sink.default.writer_identity,
  ]
}
