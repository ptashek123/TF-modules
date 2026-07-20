terraform {
  required_providers {
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = "3.0.1"
    }
    helm = {
        source  = "hashicorp/helm"
        version = "3.1.1"
    }
    vault = {
        source  = "hashicorp/vault"
        version = ">= 5.4.0"
    }
  }
  required_version = "~> 1.15.0"
}