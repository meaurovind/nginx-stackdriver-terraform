 provider "google" {
  credentials = file("account.json")
  project     = var.project
  region      = var.region

}


resource "google_bigquery_dataset" "ProjectLogging" {
    dataset_id = "ProjectLogging"
    friendly_name = "ProjectLogging"
    location = "US"
    project = var.project


    access = [
      {  role = "WRITER"
        user_by_email = "${google_logging_project_sink.ProjectSink.writer_identity}"
   ] }
}

resource "google_logging_project_sink" "ProjectSink" {
    name = "ProjectLogging"
    destination = "bigquery.googleapis.com/projects/var.project/datasets/instance-activity"
    project = var.project
    filter = "resource.type = project"
    depends_on = ["google_bigquery_dataset.ProjectLogging"]
    unique_writer_identity = true
}


resource "google_logging_project_sink" "my-sink" {
  name = "my-pubsub-instance-sink"

  # Can export to pubsub, cloud storage, or bigquery
  destination = "pubsub.googleapis.com/projects/my-project/topics/instance-activity"

  # Log all WARN or higher severity messages relating to instances
  filter = "resource.type = gce_instance AND severity >= WARN"

  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
}
