variable "linode_token" {
  sensitive = true
}

variable "ssh_private_key" {
  sensitive = true
  default = "~/.ssh/id_rsa"
}

variable "ssh_public_key" {
  sensitive = true
  default = "~/.ssh/id_rsa.pub"
}