#Defining Provider
provider "google" {
  project = "k8s-assignement"
  region  = "us-central1"
  credentials = "/Users/siva/keys/gcp/k8s-assignement-500cdb2e0cc6.json"
}

#Creating GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name               = "gke-cluster"
  location           = "us-central1-a"
  initial_node_count = 1
  min_master_version = "latest"
  deletion_protection = false
  node_config {
    machine_type = "e2-medium"
    image_type   = "COS_CONTAINERD"
    disk_type    = "pd-standard"
    disk_size_gb = 50

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

#Creating Artifact Registry repository
resource "google_artifact_registry_repository" "artifact_registry_repo" {
  repository_id = "my-repository"
  format = "DOCKER"
  location = "us-central1"
  project = "k8s-assignement"
}

#Creating compute disk
resource "google_compute_disk" "gke_pv" {
  name  = "gke-pv"
  size  = 10
  type  = "pd-standard"
  zone  = "us-central1-a"
}
