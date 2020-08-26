provider "google" {
  access_token = "ya29.a0AfH6SMA1nnWGQ3Q8ZtjVNRUwv7SW7AgrFVU1lY7LKKVqIbTQPRlDjysSmfrf5pkuinZvHXapopFrNLY8or-2X6vHu_O5zLUdW-6hpV786WzsEbZ75OLIOhwUniVxcKXGfg0B5QP85W_oUFg_u9T_89Np96Cis0kGbM0q6pdtAum6zVfGTFNkomaZH69Qo4GihoM_go96IihzBm5Cu3sarzz8470jFuef0CF9x8snQ1p2hYkSRWFgv15Kit8UXXs3om6FTJ93Kd1DDw"
  credentials = file("account.json") 
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
  unique_writer_identity = true
}

resource "google_project_iam_binding" "default" {
  role = "roles/bigquery.dataEditor"

  members = [
    google_logging_project_sink.default.writer_identity,
  ]
}
