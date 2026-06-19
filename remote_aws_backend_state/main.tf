
resource "local_file" "example" {
  filename = "/tmp/terraform-aws-test.txt"

  content = <<EOF
Hello from Terraform, Backend State Aws 👋
This file was created at: ${timestamp()}
EOF
}