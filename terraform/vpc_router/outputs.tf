output "vpc_id" {
  value = aws_vpc.router.id
}

output "vpc_cidr" {
  value = aws_vpc.router.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}
