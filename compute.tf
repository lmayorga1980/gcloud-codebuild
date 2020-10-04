resource "random_id" "instance_id"{
  byte_length = 8
}

resource  "google_compute_instance" "default"{
  name = "my-instance-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone = "us-west1-a"

  boot_disk{
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"
 metadata = {
   ssh-keys = "lmayorga:${file("~/.ssh/id_rsa_google.pub")}"
 }

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}

resource "google_compute_firewall" "default"{
  name = "flask-app-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["5000"]
  }
}




