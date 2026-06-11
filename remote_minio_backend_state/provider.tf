terraform {
  backend "s3" {
    bucket = "terraform-state"

    endpoints = {
      s3 = "http://localhost:9000"
    }

    access_key = "terraform"
    secret_key = "terraform123"

    key                         = "proxmox-vms/terraform-provision.tfstate"
    region                      = "main"
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  required_version = ">=1.2, < 1.10"
}
