output "router_public_ip" {
  description = "Public IP address of the software router"
  value       = aws_instance.router_placeholder.public_ip
}
