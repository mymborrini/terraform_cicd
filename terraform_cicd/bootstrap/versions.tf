terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "tf-state"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"

    dynamodb_table = "tf-state-lock"

    endpoints = {
      s3       = "http://localhost:4566"
      dynamodb = "http://localhost:4566"
    }

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true

    use_path_style = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  # Local backend: bootstrap state lives at ./state/bootstrap.tfstate.
  #   terraform init -backend-config=backends/bootstrap.hcl
  # For a shared team setup, switch to `backend "s3" {}`.
  # backend "local" {}
}