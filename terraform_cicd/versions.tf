terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "tf-state"
    key            = "${var.environment}/terraform.tfstate"
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
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }

  # Local backend: state lives on disk under ./state/<env>.tfstate. The path is
  # supplied per env at init time so each env keeps its own state file:
  #   terraform init -backend-config=backends/<env>.hcl
  # Local state is simple and great for learning or a solo demo. For a real
  # team, switch this to `backend "s3" {}` so state is shared and locked.
  #backend "local" {}
}