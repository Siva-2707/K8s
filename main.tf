provider "google" {
  project = "k8s-assignement"
  region  = "us-central1"
  credentials = "/Users/siva/keys/gcp/k8s-assignement-500cdb2e0cc6.json"
}

# Step 1: Create a GKE cluster
resource "google_container_cluster" "gke_cluster" {
  name               = "gke-cluster"
  location           = "us-central1-a"
  initial_node_count = 1
  min_master_version = "latest"
  deletion_protection = false
  node_config {
    machine_type = "e2-micro"
    image_type   = "COS_CONTAINERD"
    disk_type    = "pd-standard"
    disk_size_gb = 10

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

# Step 2: Create an Artifact Registry repository
resource "google_artifact_registry_repository" "artifact_registry_repo" {
  repository_id = "my-repository"
  format = "DOCKER"
  location = "us-central1"
  project = "k8s-assignement"
}

# Step 4: Create a Persistent Volume for GKE
# resource "google_compute_disk" "gke_pv" {
#   name  = "gke-pv"
#   size  = 10
#   type  = "pd-standard"
#   zone  = "us-central1-a"
# }
#
# resource "kubernetes_persistent_volume" "k8s_persistent_volume" {
#   metadata {
#     name = "gke-pv-disk"
#   }
#   spec {
#     capacity = {
#       storage = "10Gi"
#     }
#     access_modes = ["ReadWriteMany"]
#     persistent_volume_source {
#       gce_persistent_disk {
#         pd_name = google_compute_disk.gke_pv.name
#       }
#     }
#   }
# }
#
# # # Step 5: Create a Persistent Volume Claim for GKE
# resource "kubernetes_persistent_volume_claim" "gke_pvc" {
#   metadata {
#     name = "gke-pvc"
#   }
#   spec {
#     access_modes = ["ReadWriteMany"]
#     resources {
#       requests = {
#         storage = "10Gi"
#       }
#     }
#     volume_name = kubernetes_persistent_volume.k8s_persistent_volume.metadata[0].name
#   }
# }


# output "gke_cluster_name" {
#   value = google_container_cluster.gke_cluster.name
# }
#
# output "gke_cluster_endpoint" {
#   value = google_container_cluster.gke_cluster.endpoint
# }
