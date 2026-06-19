
resource "local_file" "example" {
  filename = "/tmp/terraform-minio-test.txt"

  content = <<EOF
Hello from Terraform, Backend State Minio 👋
This file was created at: ${timestamp()}
EOF
}