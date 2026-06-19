terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"

    }
     local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  required_version = ">=1.2, < 1.10"
}