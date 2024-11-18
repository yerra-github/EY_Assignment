# main.tf

# Provider configuration for Google Cloud
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Define the GKE Cluster
resource "google_container_cluster" "primary" {
  name     = "gke-cluster"
  location = var.region

  initial_node_count = 2

  # Enable the auto-scaling feature
  enable_autoscaling = true

  # Node pool configuration
  node_config {
    machine_type = "e2-medium"  # Machine type for nodes
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  # Autoscaler configuration (max 5 nodes)
  autoscaling {
    min_node_count = 2
    max_node_count = 5
  }

  # Enable Kubernetes Engine monitoring
  addons_config {
    cloud_run_config {
      disabled = true
    }
  }
}

# Define the Kubernetes provider (for managing resources within the cluster)
provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(google_container_cluster.primary.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

# Output the cluster's Kubeconfig for use by kubectl
output "kubeconfig" {
  value = google_container_cluster.primary.kube_config[0].raw
}

