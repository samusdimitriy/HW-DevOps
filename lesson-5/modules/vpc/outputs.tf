output "vpc_id" {
  description = "ID створеної VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "Список ID публічних підмереж"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnets" {
  description = "Список ID приватних підмереж"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "internet_gateway_id" {
  description = "ID Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "ID NAT Gateway"
  value       = aws_nat_gateway.this.id
}

output "public_route_table_id" {
  description = "ID маршрутної таблиці для публічних підмереж"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID маршрутної таблиці для приватних підмереж"
  value       = aws_route_table.private.id
}
