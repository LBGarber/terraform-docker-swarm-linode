variable "linode_token" {
  sensitive = true
}

variable "parent_type" {
  default = "g6-standard-2"
}

variable "child_type" {
  default = "g6-standard-2"
}

variable "region" {
  default = "us-southeast"
}

variable "label_prefix" {
  default = "tf"
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