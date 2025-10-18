# Root outputs.tf - Exports important values

# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_arn" {
  description = "VPC ARN"
  value       = module.vpc.vpc_arn
}

output "s3_endpoint_id" {
  description = "S3 VPC Endpoint ID"
  value       = module.vpc.s3_endpoint_id
}

output "dynamodb_endpoint_id" {
  description = "DynamoDB VPC Endpoint ID"
  value       = module.vpc.dynamodb_endpoint_id
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.subnets.private_subnet_ids
}

output "db_subnet_ids" {
  description = "Database subnet IDs"
  value       = module.subnets.db_subnet_ids
}

output "db_subnet_group_name" {
  description = "RDS subnet group name"
  value       = module.subnets.db_subnet_group_name
}

output "public_nacl_id" {
  description = "Public Network ACL ID"
  value       = module.subnets.public_nacl_id
}

output "private_nacl_id" {
  description = "Private Network ACL ID"
  value       = module.subnets.private_nacl_id
}

output "database_nacl_id" {
  description = "Database Network ACL ID"
  value       = module.subnets.database_nacl_id
}

# Gateway Outputs
output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.gateways.internet_gateway_id
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.gateways.nat_gateway_ids
}

output "nat_elastic_ips" {
  description = "Public IPs for NAT Gateways"
  value       = module.gateways.nat_elastic_ips
}

output "nat_gateways_details" {
  description = "NAT Gateways detailed information"
  value       = module.gateways.nat_gateways_details
}

output "nat_gateway_count" {
  description = "Number of NAT Gateways"
  value       = module.gateways.nat_gateway_count
}

# Routing Outputs
output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = module.routing.public_route_table_id
}

output "private_route_table_ids" {
  description = "Private Route Table IDs"
  value       = module.routing.private_route_table_ids
}

output "database_route_table_id" {
  description = "Database Route Table ID"
  value       = module.routing.database_route_table_id
}

output "routing_summary" {
  description = "Complete routing configuration summary"
  value       = module.routing.routing_summary
}

# Security Groups Outputs
output "load_balancer_security_group_id" {
  description = "Load Balancer Security Group ID"
  value       = module.security.load_balancer_security_group_id
}

output "application_security_group_id" {
  description = "Application Security Group ID"
  value       = module.security.application_security_group_id
}

output "cache_security_group_id" {
  description = "Cache Security Group ID"
  value       = module.security.cache_security_group_id
}

output "database_security_group_id" {
  description = "Database Security Group ID"
  value       = module.security.database_security_group_id
}

output "internal_security_group_id" {
  description = "Internal Security Group ID"
  value       = module.security.internal_security_group_id
}

output "security_groups_summary" {
  description = "Summary of all security groups"
  value       = module.security.security_groups_summary
}

# RDS Outputs
output "primary_db_instance_id" {
  description = "Primary RDS instance identifier"
  value       = module.rds.primary_db_instance_id
}

output "primary_db_address" {
  description = "Primary RDS instance address (hostname only)"
  value       = module.rds.primary_db_address
}

output "primary_db_port" {
  description = "Primary RDS instance port"
  value       = module.rds.primary_db_port
}

output "primary_db_endpoint" {
  description = "Primary RDS endpoint (address:port)"
  value       = module.rds.primary_db_endpoint
}

output "primary_db_arn" {
  description = "Primary RDS instance ARN"
  value       = module.rds.primary_db_arn
}

output "read_replica_az2_id" {
  description = "Read replica AZ2 instance identifier"
  value       = module.rds.read_replica_az2_id
}

output "read_replica_az2_address" {
  description = "Read replica AZ2 address"
  value       = module.rds.read_replica_az2_address
}

output "read_replica_az3_id" {
  description = "Read replica AZ3 instance identifier"
  value       = module.rds.read_replica_az3_id
}

output "read_replica_az3_address" {
  description = "Read replica AZ3 address"
  value       = module.rds.read_replica_az3_address
}

output "rds_summary" {
  description = "Complete RDS infrastructure summary"
  value       = module.rds.rds_summary
}
