provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

data "template_file" "default" {
  template = "${file("scripts/install.sh")}"
}

resource "google_compute_firewall" "default" {
 name    = "nginx-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["80"]
 }

 source_ranges = ["0.0.0.0/0"]
 target_tags = ["nginx"]
}

resource "google_compute_instance" "default" {
  name         = "nginx"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["nginx"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    network = "default"

    access_config {}
  }

  metadata_startup_script = "${data.template_file.default.rendered}"

  service_account {
    scopes = ["logging-write"]
  }
}
