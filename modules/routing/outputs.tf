# modules/routing/outputs.tf

# Public Route Table
output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public.id
}

output "public_route_table_arn" {
  description = "Public Route Table ARN"
  value       = aws_route_table.public.arn
}

output "public_route_table_routes" {
  description = "Public Route Table routes"
  value       = aws_route_table.public.route
}

# Private Route Tables
output "private_route_table_ids" {
  description = "Private Route Table IDs"
  value       = aws_route_table.private[*].id
}

output "private_route_table_count" {
  description = "Number of Private Route Tables"
  value       = length(aws_route_table.private)
}

output "private_route_table_routes" {
  description = "Private Route Table routes"
  value       = aws_route_table.private[*].route
}

# Database Route Table
output "database_route_table_id" {
  description = "Database Route Table ID"
  value       = aws_route_table.database.id
}

output "database_route_table_arn" {
  description = "Database Route Table ARN"
  value       = aws_route_table.database.arn
}

output "database_route_table_routes" {
  description = "Database Route Table routes"
  value       = aws_route_table.database.route
}

# Route Table Associations Summary
output "public_subnet_associations" {
  description = "Public subnet to route table associations"
  value       = length(aws_route_table_association.public)
}

output "private_subnet_associations" {
  description = "Private subnet to route table associations"
  value       = length(aws_route_table_association.private)
}

output "database_subnet_associations" {
  description = "Database subnet to route table associations"
  value       = length(aws_route_table_association.database)
}

# Routing Summary
output "routing_summary" {
  description = "Routing configuration summary"
  value = {
    public_rt = {
      id      = aws_route_table.public.id
      route   = "0.0.0.0/0 → Internet Gateway"
      subnets = length(aws_route_table_association.public)
    }
    private_rt = {
      count   = length(aws_route_table.private)
      route   = "0.0.0.0/0 → NAT Gateway"
      subnets = length(aws_route_table_association.private)
    }
    database_rt = {
      id      = aws_route_table.database.id
      route   = "No internet route (isolated)"
      subnets = length(aws_route_table_association.database)
    }
  }
}
