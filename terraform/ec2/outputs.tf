output "router_public_ip" {
  description = "Public IP address of the software router"
  value       = aws_instance.router.public_ip
}

output "router_public_ip" {
  description = "Private IP of the router (null — router sits on a private/peered path, no public IP)"
  value       = aws_instance.router.private_ip   # was .router_placeholder.public_ip
}
