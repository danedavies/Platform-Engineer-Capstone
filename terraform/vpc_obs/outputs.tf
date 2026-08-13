output "vpc_id" {
  value = aws_vpc.obs.id
}

output "vpc_cidr" {
  value = aws_vpc.obs.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "private_rt_id" {
  value = aws_route_table.private_rt.id
}
