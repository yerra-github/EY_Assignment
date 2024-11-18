# variable.tf

# Define the variables
variable "project_id" {
  description = "The project ID for the GKE cluster"
  type        = string
}

variable "region" {
  description = "The region for the GKE cluster"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone for the GKE cluster"
  type        = string
  default     = "us-central1-a"
}

