resource "aws_instance" "router" {
  ami           = "ami-0279549f721af0ad1"
  instance_type = "c5.large"

  subnet_id              = var.router_public_subnet
  vpc_security_group_ids = [aws_security_group.router.id]

  associate_public_ip_address = false
  source_dest_check           = false

  tags = {
    Name    = "Cisco-C8K Router"
    Project = "capstone"
    Role    = "router"
  }
}
