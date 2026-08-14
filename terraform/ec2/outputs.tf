output "router_public_ip" {
  description = "Public IP address of the software router"
  value       = aws_instance.router_placeholder.public_ip
}
output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}