provider "google" {
  credentials = file("account.json") 
  project     = "ci-pipeline-276501"
  region      = "us-central1"

}

resource "google_bigquery_dataset" "ProjectLogging" {
    dataset_id = "ProjectLogging"
    friendly_name = "ProjectLogging"
    location = "US"
    project = "${google_project.project.project_id}" 
    

    access = {
        role = "WRITER"
        user_by_email = "${google_logging_project_sink.ProjectSink.writer_identity}"
    }
}

resource "google_logging_project_sink" "ProjectSink" {
    name = "ProjectLogging"
    destination = "bigquery.googleapis.com/projects/${google_project.project.project_id}/datasets/ProjectLogging"
    project = "${google_project.project.project_id}"
    filter = "resource.type = project"
    depends_on = ["google_bigquery_dataset.ProjectLogging"]
    unique_writer_identity = true
}
