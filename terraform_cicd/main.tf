
resource "null_resource" "Hello" {
  
  triggers = {
    name = local.name
    environment = var.environment
    note = var.note
  }

  provisioner "local-exec" {
    command = "echo 'Deployed ${local.name}: ${var.note}'"
  }

}