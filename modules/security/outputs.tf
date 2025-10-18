# modules/security/outputs.tf

# Load Balancer Security Group
output "load_balancer_security_group_id" {
  description = "Load Balancer Security Group ID"
  value       = aws_security_group.load_balancer.id
}

output "load_balancer_security_group_arn" {
  description = "Load Balancer Security Group ARN"
  value       = aws_security_group.load_balancer.arn
}

output "load_balancer_security_group_name" {
  description = "Load Balancer Security Group Name"
  value       = aws_security_group.load_balancer.name
}

# Application Security Group
output "application_security_group_id" {
  description = "Application Security Group ID"
  value       = aws_security_group.application.id
}

output "application_security_group_arn" {
  description = "Application Security Group ARN"
  value       = aws_security_group.application.arn
}

output "application_security_group_name" {
  description = "Application Security Group Name"
  value       = aws_security_group.application.name
}

# Cache Security Group
output "cache_security_group_id" {
  description = "Cache Security Group ID"
  value       = aws_security_group.cache.id
}

output "cache_security_group_arn" {
  description = "Cache Security Group ARN"
  value       = aws_security_group.cache.arn
}

output "cache_security_group_name" {
  description = "Cache Security Group Name"
  value       = aws_security_group.cache.name
}

# Database Security Group
output "database_security_group_id" {
  description = "Database Security Group ID"
  value       = aws_security_group.database.id
}

output "database_security_group_arn" {
  description = "Database Security Group ARN"
  value       = aws_security_group.database.arn
}

output "database_security_group_name" {
  description = "Database Security Group Name"
  value       = aws_security_group.database.name
}

# Internal Security Group
output "internal_security_group_id" {
  description = "Internal Security Group ID"
  value       = aws_security_group.internal.id
}

output "internal_security_group_arn" {
  description = "Internal Security Group ARN"
  value       = aws_security_group.internal.arn
}

output "internal_security_group_name" {
  description = "Internal Security Group Name"
  value       = aws_security_group.internal.name
}

# Security Groups Summary
output "security_groups_summary" {
  description = "Summary of all security groups"
  value = {
    load_balancer = {
      id   = aws_security_group.load_balancer.id
      name = aws_security_group.load_balancer.name
      desc = "ALB - Allows HTTP/HTTPS from internet"
    }
    application = {
      id   = aws_security_group.application.id
      name = aws_security_group.application.name
      desc = "App Servers - Allows traffic from ALB"
    }
    cache = {
      id   = aws_security_group.cache.id
      name = aws_security_group.cache.name
      desc = "Cache Layer - Allows traffic from App"
    }
    database = {
      id   = aws_security_group.database.id
      name = aws_security_group.database.name
      desc = "RDS Database - Allows traffic from App"
    }
    internal = {
      id   = aws_security_group.internal.id
      name = aws_security_group.internal.name
      desc = "Internal - VPC and self-communication"
    }
  }
}
