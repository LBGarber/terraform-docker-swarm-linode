output "parent_ip" {
  value = linode_instance.parent.ip_address
}

output "child_ips" {
  value = linode_instance.child.*.ip_address
}