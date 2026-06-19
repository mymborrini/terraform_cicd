module "remote_minio_backend_state" {
  source = "./remote_minio_backend_state"
}

module "remote_aws_backend_state" {
  count  = 0
  source = "./remote_aws_backend_state"
}