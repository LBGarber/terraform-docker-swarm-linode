resource "linode_instance" "parent" {
  label = "swarm-parent"
  image = "linode/ubuntu20.04"
  region = "us-southeast"
  type = "g6-standard-1"
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

  provisioner "local-exec" {
    command = "scp -i ${var.ssh_private_key} root@${self.ip_address}:/root/swarmoutput.txt swarm_output.txt"
  }
}

data "external" "grab_token" {
  depends_on = [linode_instance.parent]

  program = ["python", "${path.module}/scripts/get_token.py"]

  query = {
    # arbitrary map from strings to strings, passed
    # to the external program as the data query.
    input_file = "swarm_output.txt"
  }
}

resource "local_file" "rendered_provisioner" {
  depends_on = [linode_instance.parent, data.external.grab_token]

  count = 4

  content  = templatefile("${path.module}/scripts/provision_child.sh.tpl", {token=data.external.grab_token.result.token, public_ip=linode_instance.parent.ip_address})
  filename = "${path.module}/provisioner-${count.index}.sh"
}

resource "linode_instance" "child" {
  count = 4

  depends_on = [local_file.rendered_provisioner]

  label = "swarm-child-${count.index}"
  image = "linode/ubuntu20.04"
  region = "us-southeast"
  type = "g6-standard-1"
  authorized_keys = [chomp(file(var.ssh_public_key))]

  connection {
    type = "ssh"
    user = "root"
    private_key = chomp(file(var.ssh_private_key))
    host = self.ip_address
  }

  provisioner "remote-exec" {
    script = "${path.module}/provisioner-${count.index}.sh"
  }
}