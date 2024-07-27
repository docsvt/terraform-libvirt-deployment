resource "tls_private_key" "this" {
  count     = var.public_ssh_key_path != "" ? 0 : 1
  algorithm = "ED25519"
  rsa_bits  = 2048

  provisioner "local-exec" {
    # create a new one, chmod permissions of the new key, add to key chain
    when    = create
    command = "echo '${self.private_key_openssh}' > ~/.ssh/${self.id}.pem; chmod 0400 ~/.ssh/${self.id}.pem"
  }

  # When this resources is destroyed, delete the associated key from the file system
  provisioner "local-exec" {
    when    = destroy
    command = "rm ~/.ssh/${self.id}.pem"
  }
}

resource "random_password" "this" {
  count = var.vm_admin_user_password != "" ? 0 : 1
  length           = 16
  special          = true
  override_special = "_%@"
}
