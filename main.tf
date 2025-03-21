provider "google" {
  project = "k8s-assignement"
  region  = "us-central1"
  credentials = "/Users/siva/keys/gcp/k8s-assignement-7e4a75f151cc.json"
}

# Step 1: Create a GKE cluster
resource "google_container_cluster" "gke_cluster" {
  name               = "gke-cluster"
  location           = "us-central1-a"
  initial_node_count = 1
  min_master_version = "latest"
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

# Step 3: Cloud Build Trigger to build Docker image from GitLab repository
resource "google_cloudbuild_trigger" "cloudbuild_trigger" {
  name        = "cloudbuild-trigger"
  description = "Trigger for building Docker image from GitLab"

  github {
    owner = "courses/2025-winter/csci-4145_5409"
    name  = "balamurali"
    push {
      branch = "main"
    }
  }

  build {
    step {
      name = "gcr.io/cloud-builders/docker/container-builder-1"
      args = ["build", "-t", "us-central1-docker.pkg.dev/k8s-assignement/my-repository/container-1", "./K8s/data-validator/"]
    }
    step {
      name = "gcr.io/cloud-builders/docker/continer-builder-2"
      args = ["build", "-t", "us-central1-docker.pkg.dev/k8s-assignement/my-repository/container-2", "./K8s/data-processor/"]
    }
    images = [
      "us-central1-docker.pkg.dev/k8s-assignement/my-repository/container-1",
      "us-central1-docker.pkg.dev/k8s-assignement/my-repository/container-2"
    ]
  }
}

# Step 4: Create a Persistent Volume for GKE
resource "google_compute_disk" "gke_pv" {
  name  = "gke-pv-disk"
  size  = 100
  type  = "pd-standard"
  zone  = "us-central1-a"
}

# Step 5: Create a Persistent Volume Claim for GKE
resource "kubernetes_persistent_volume_claim" "gke_pvc" {
  metadata {
    name = "gke-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "100Gi"
      }
    }
    volume_name = google_compute_disk.gke_pv.name
  }
}

# Step 6: Deploy the container in GKE with Persistent Volume
resource "kubernetes_deployment" "gke_deployment" {
  metadata {
    name = "project-a-deployment"
    labels = {
      app = "project-a"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "project-a"
      }
    }
    template {
      metadata {
        labels = {
          app = "project-a"
        }
      }
      spec {
        container {
          name  = "container-1"
          image = "us-central1-docker.pkg.dev/k8s-assignement/my-repository/container-1"
          volume_mount {
            mount_path = "/mnt/disks"
            name       = "gke-pv"
          }
        }
        container {
          name  = "container-2"
          image = "us-central1-docker.pkg.dev/k8s-assignement/my-repository/container-2"
          volume_mount {
            mount_path = "/mnt/disks"
            name       = "gke-pv"
          }
        }
        volume {
          name = "gke-pv"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.gke_pvc.metadata[0].name
          }
        }
      }
    }
  }
}
# Step 7: Create a Kubernetes Service to expose the deployment
resource "kubernetes_service" "gke_service" {
  metadata {
    name = "project-a-service"
  }
  spec {
    selector = {
      app = "project-a"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}

output "gke_cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "gke_cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}
