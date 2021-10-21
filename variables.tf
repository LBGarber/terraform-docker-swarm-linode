variable "linode_token" {
  sensitive = true
}

variable "child_count" {
  default = 6
}

variable "ssh_private_key" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}