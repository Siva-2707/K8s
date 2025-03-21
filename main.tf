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

# resource "google_cloudbuildv2_connection" "my-connection" {
#   location = "us-central1"
#   name = "my-connection"
#
#   github_config {
#     app_installation_id = 123123
#     authorizer_credential {
#       oauth_token_secret_version = "projects/my-project/secrets/github-pat-secret/versions/latest"
#     }
#   }
# }

# resource "google_cloudbuildv2_repository" "my-repository" {
#   name = "K8s"
#   parent_connection = google_cloudbuildv2_connection.my-connection.id
#   remote_uri = "https://github.com/Siva-2707/K8s"
# }

# Step 3: Cloud Build Trigger to build Docker image from GitLab repository
# resource "google_cloudbuild_trigger" "my_cloud_build_trigger"{
#   name = "cloudbuild-trigger"
#   description = "Trigger for building Docker image from GitLab"
#   location = "us-central1"
#   filename = "cloudbuild.yml"
#
#   trigger_template {
#     branch_name = "main"
#     repo_name   = "K8s"
#   }
#
#   approval_config {
#     approval_required = false
#   }
#
#   github {
#     owner = "Siva-2707"
#     name  = "K8s"
#     push {
#       branch = "main"
#     }
#   }
# }

# Step 4: Create a Persistent Volume for GKE
resource "google_compute_disk" "gke_pv" {
  name  = "gke-pv-disk"
  size  = 100
  type  = "pd-standard"
  zone  = "us-central1-a"
}

# # Step 5: Create a Persistent Volume Claim for GKE
# resource "kubernetes_persistent_volume_claim" "gke_pvc" {
#   metadata {
#     name = "gke-pvc"
#   }
#   spec {
#     access_modes = ["ReadWriteOnce"]
#     resources {
#       requests = {
#         storage = "100Gi"
#       }
#     }
#     volume_name = google_compute_disk.gke_pv.name
#   }
# }

# Step 6: Deploy the container in GKE with Persistent Volume
# resource "kubernetes_deployment" "gke_deployment" {
#   metadata {
#     name = "project-a-deployment"
#     labels = {
#       app = "project-a"
#     }
#   }
#   spec {
#     replicas = 2
#     selector {
#       match_labels = {
#         app = "project-a"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "project-a"
#         }
#       }
#       spec {
#         container {
#           name  = "container-1"
#           image = "us-central1-docker.pkg.dev/k8s-assignement/my-repository/container-1"
#           volume_mount {
#             mount_path = "/app/files"
#             name       = "gke-pv"
#           }
#         }
#         container {
#           name  = "container-2"
#           image = "us-central1-docker.pkg.dev/k8s-assignement/my-repository/container-2"
#           volume_mount {
#             mount_path = "/app/files"
#             name       = "gke-pv"
#           }
#         }
#         volume {
#           name = "gke-pv"
#           persistent_volume_claim {
#             claim_name = kubernetes_persistent_volume_claim.gke_pvc.metadata.0.name
#           }
#         }
#       }
#     }
#   }
# }
# Step 7: Create a Kubernetes Service to expose the deployment
# resource "kubernetes_service" "gke_service" {
#   metadata {
#     name = "project-a-service"
#   }
#   spec {
#     selector = {
#       app = "project-a"
#     }
#     port {
#       port        = 80
#       target_port = 8080
#     }
#     type = "LoadBalancer"
#   }
# }

output "gke_cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "gke_cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}
