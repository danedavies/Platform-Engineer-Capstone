output "vpc_id" {
  value = aws_vpc.app.id
}

output "vpc_cidr" {
  value = aws_vpc.app.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_1_id" {
  value = aws_subnet.private_1.id
}

output "private_2_id" {
  value = aws_subnet.private_2.id
}

output "private_route_table_id" {
  value = aws_route_table.private_rt.id
}
