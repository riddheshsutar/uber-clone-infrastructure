# modules/rds/outputs.tf

# Primary Database Instance Outputs
output "primary_db_instance_id" {
  description = "Primary RDS instance identifier"
  value       = aws_db_instance.primary.id
}

output "primary_db_endpoint" {
  description = "Primary RDS instance endpoint"
  value       = aws_db_instance.primary.endpoint
  sensitive   = false
}

output "primary_db_address" {
  description = "Primary RDS instance address (hostname only)"
  value       = aws_db_instance.primary.address
}

output "primary_db_port" {
  description = "Primary RDS instance port"
  value       = aws_db_instance.primary.port
}

output "primary_db_arn" {
  description = "Primary RDS instance ARN"
  value       = aws_db_instance.primary.arn
}

output "primary_db_availability_zone" {
  description = "Primary RDS instance availability zone"
  value       = aws_db_instance.primary.availability_zone
}

# Read Replica AZ2 Outputs
output "read_replica_az2_id" {
  description = "Read replica AZ2 instance identifier"
  value       = aws_db_instance.read_replica_az2.id
}

output "read_replica_az2_endpoint" {
  description = "Read replica AZ2 endpoint"
  value       = aws_db_instance.read_replica_az2.endpoint
  sensitive   = false
}

output "read_replica_az2_address" {
  description = "Read replica AZ2 address (hostname only)"
  value       = aws_db_instance.read_replica_az2.address
}

output "read_replica_az2_port" {
  description = "Read replica AZ2 port"
  value       = aws_db_instance.read_replica_az2.port
}

output "read_replica_az2_availability_zone" {
  description = "Read replica AZ2 availability zone"
  value       = aws_db_instance.read_replica_az2.availability_zone
}

# Read Replica AZ3 Outputs
output "read_replica_az3_id" {
  description = "Read replica AZ3 instance identifier"
  value       = aws_db_instance.read_replica_az3.id
}

output "read_replica_az3_endpoint" {
  description = "Read replica AZ3 endpoint"
  value       = aws_db_instance.read_replica_az3.endpoint
  sensitive   = false
}

output "read_replica_az3_address" {
  description = "Read replica AZ3 address (hostname only)"
  value       = aws_db_instance.read_replica_az3.address
}

output "read_replica_az3_port" {
  description = "Read replica AZ3 port"
  value       = aws_db_instance.read_replica_az3.port
}

output "read_replica_az3_availability_zone" {
  description = "Read replica AZ3 availability zone"
  value       = aws_db_instance.read_replica_az3.availability_zone
}

# Database Connection Details
output "database_connection_string_primary" {
  description = "Primary database connection string"
  value       = "mysql -h ${aws_db_instance.primary.address} -u ${var.db_username} -p ${var.db_name}"
  sensitive   = true
}

output "database_connection_string_read_replica_az2" {
  description = "Read replica AZ2 connection string"
  value       = "mysql -h ${aws_db_instance.read_replica_az2.address} -u ${var.db_username} -p ${var.db_name}"
  sensitive   = true
}

output "database_connection_string_read_replica_az3" {
  description = "Read replica AZ3 connection string"
  value       = "mysql -h ${aws_db_instance.read_replica_az3.address} -u ${var.db_username} -p ${var.db_name}"
  sensitive   = true
}

# RDS Summary
output "rds_summary" {
  description = "Complete RDS infrastructure summary"
  value = {
    primary = {
      identifier        = aws_db_instance.primary.id
      address           = aws_db_instance.primary.address
      port              = aws_db_instance.primary.port
      availability_zone = aws_db_instance.primary.availability_zone
      engine            = aws_db_instance.primary.engine
      engine_version    = aws_db_instance.primary.engine_version
      multi_az          = aws_db_instance.primary.multi_az
    }
    read_replicas = {
      az2 = {
        identifier        = aws_db_instance.read_replica_az2.id
        address           = aws_db_instance.read_replica_az2.address
        availability_zone = aws_db_instance.read_replica_az2.availability_zone
      }
      az3 = {
        identifier        = aws_db_instance.read_replica_az3.id
        address           = aws_db_instance.read_replica_az3.address
        availability_zone = aws_db_instance.read_replica_az3.availability_zone
      }
    }
  }
}

# Monitoring
output "monitoring_role_arn" {
  description = "IAM role ARN for RDS monitoring"
  value       = aws_iam_role.rds_monitoring_role.arn
}

# Parameter Group
output "parameter_group_id" {
  description = "Parameter group ID"
  value       = aws_db_parameter_group.main.id
}
