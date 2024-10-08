output "vpc_id" {
  value       = aws_vpc.main_vpc.id
  description = "ID of the created VPC"
}

output "public_subnet_1_id" {
  value       = aws_subnet.public_subnet_1.id
  description = "ID of the first public subnet"
}

output "public_subnet_2_id" {
  value       = aws_subnet.public_subnet_2.id
  description = "ID of the second public subnet"
}

output "private_subnet_1_id" {
  value       = aws_subnet.private_subnet_1.id
  description = "ID of the first private subnet"
}

output "private_subnet_2_id" {
  value       = aws_subnet.private_subnet_2.id
  description = "ID of the second private subnet"
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_gw.id
}

output "public_route_table_id" {
  description = "ID of the created public route table" 
  value       = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  description = "ID of the created public route table"
  value       = aws_route_table.private_rt.id
}
