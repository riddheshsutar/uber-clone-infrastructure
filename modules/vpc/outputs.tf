# modules/vpc/outputs.tf

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "vpc_arn" {
  description = "VPC ARN"
  value       = aws_vpc.main.arn
}

output "vpc_enable_dns_hostnames" {
  description = "DNS hostnames enabled status"
  value       = aws_vpc.main.enable_dns_hostnames
}

output "vpc_enable_dns_support" {
  description = "DNS support enabled status"
  value       = aws_vpc.main.enable_dns_support
}

output "s3_endpoint_id" {
  description = "S3 VPC Endpoint ID"
  value       = aws_vpc_endpoint.s3.id
}

output "dynamodb_endpoint_id" {
  description = "DynamoDB VPC Endpoint ID"
  value       = aws_vpc_endpoint.dynamodb.id
}

output "vpc_flow_logs_group_name" {
  description = "CloudWatch Log Group for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.vpc_flow_logs.name
}
