# Our logged compute instance
resource "google_compute_instance" "my-logged-instance" {
  name         = "my-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }
}

# A bucket to store logs in
resource "google_storage_bucket" "log-bucket" {
  name = "my-unique-logging-bucket"
}

# Our sink; this logs all activity related to our "my-logged-instance" instance
resource "google_logging_project_sink" "instance-sink" {
  name        = "my-instance-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.log-bucket.name}"
  filter      = "resource.type = gce_instance AND resource.labels.instance_id = \"${google_compute_instance.my-logged-instance.instance_id}\""

  unique_writer_identity = true
}

# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
resource "google_project_iam_binding" "log-writer" {
  role = "roles/storage.objectCreator"

  members = [
    google_logging_project_sink.instance-sink.writer_identity,
  ]
}
