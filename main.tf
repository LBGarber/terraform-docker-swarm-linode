resource "linode_instance" "parent" {
  label = "${var.label_prefix}-swarm-parent"
  image = "linode/ubuntu20.04"
  region = var.region
  type = var.parent_type
  authorized_keys = [chomp(file(var.ssh_public_key))]

  connection {
    type = "ssh"
    user = "root"
    private_key = chomp(file(var.ssh_private_key))
    host = self.ip_address
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/provision_parent.sh"
  }
}

resource "linode_instance" "child" {
  count = var.child_count

  depends_on = [local_file.rendered_provisioner]

  label = "${var.label_prefix}-swarm-child-${count.index}"
  image = "linode/ubuntu20.04"
  region = var.region
  type = var.child_type
  authorized_keys = [chomp(file(var.ssh_public_key))]

  connection {
    type = "ssh"
    user = "root"
    private_key = chomp(file(var.ssh_private_key))
    host = self.ip_address
  }

  provisioner "remote-exec" {
    script = "${path.module}/tmp/provisioner-${count.index}.sh"
  }
}

// Script to extract the token from output
data "external" "grab_token" {
  depends_on = [linode_instance.parent]

  program = ["python", "${path.module}/scripts/get_token.py"]

  query = {
    ssh_private_key = var.ssh_private_key
    ip_address = linode_instance.parent.ip_address
  }
}

resource "local_file" "rendered_provisioner" {
  depends_on = [linode_instance.parent, data.external.grab_token]

  count = var.child_count

  content  = templatefile("${path.module}/scripts/provision_child.sh.tpl", {token=data.external.grab_token.result.token, public_ip=linode_instance.parent.ip_address})
  filename = "${path.module}/tmp/provisioner-${count.index}.sh"
}
