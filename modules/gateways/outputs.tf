# modules/gateways/outputs.tf

# Internet Gateway Outputs
output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

output "internet_gateway_arn" {
  description = "Internet Gateway ARN"
  value       = aws_internet_gateway.main.arn
}

# Elastic IPs Outputs
output "nat_elastic_ips" {
  description = "Elastic IPs for NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

output "nat_elastic_ips_full" {
  description = "Full details of Elastic IPs"
  value = {
    for idx, eip in aws_eip.nat :
    idx => {
      public_ip     = eip.public_ip
      allocation_id = eip.id
    }
  }
}

# NAT Gateway Outputs
output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = aws_nat_gateway.main[*].id
}

output "nat_gateways_details" {
  description = "NAT Gateways details (ID, Public IP, Subnet ID)"
  value = {
    for idx, nat in aws_nat_gateway.main :
    idx => {
      id        = nat.id
      public_ip = aws_eip.nat[idx].public_ip
      subnet_id = nat.subnet_id
    }
  }
}

# NAT Gateway Count
output "nat_gateway_count" {
  description = "Number of NAT Gateways created"
  value       = length(aws_nat_gateway.main)
}

# Flow Logs Outputs
output "nat_flow_logs_group_name" {
  description = "CloudWatch Log Group name for NAT Flow Logs"
  value       = aws_cloudwatch_log_group.nat_flow_logs.name
}
