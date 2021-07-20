output "aws_vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "vpc_main_route_table_id" {
  value = aws_vpc.vpc.main_route_table_id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnets.*.id
}