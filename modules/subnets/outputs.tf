# modules/subnets/outputs.tf

# Public Subnets
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = aws_subnet.public[*].cidr_block
}

output "public_subnets" {
  description = "Public subnet details"
  value = {
    for subnet in aws_subnet.public :
    subnet.id => {
      cidr_block        = subnet.cidr_block
      availability_zone = subnet.availability_zone
    }
  }
}

# Private Subnets
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = aws_subnet.private[*].cidr_block
}

output "private_subnets" {
  description = "Private subnet details"
  value = {
    for subnet in aws_subnet.private :
    subnet.id => {
      cidr_block        = subnet.cidr_block
      availability_zone = subnet.availability_zone
    }
  }
}

# Database Subnets
output "db_subnet_ids" {
  description = "List of database subnet IDs"
  value       = aws_subnet.database[*].id
}

output "db_subnet_cidrs" {
  description = "List of database subnet CIDR blocks"
  value       = aws_subnet.database[*].cidr_block
}

output "db_subnet_group_name" {
  description = "Database subnet group name"
  value       = aws_db_subnet_group.main.name
}

output "db_subnet_group_id" {
  description = "Database subnet group ID"
  value       = aws_db_subnet_group.main.id
}

# Network ACLs
output "public_nacl_id" {
  description = "Public Network ACL ID"
  value       = aws_network_acl.public.id
}

output "private_nacl_id" {
  description = "Private Network ACL ID"
  value       = aws_network_acl.private.id
}

output "database_nacl_id" {
  description = "Database Network ACL ID"
  value       = aws_network_acl.database.id
}
