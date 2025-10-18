# modules/vpc/main.tf
# Create VPC (Virtual Private Cloud)
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-vpc-${var.environment}"
    }
  )
}

# Enable VPC Flow Logs for monitoring and security
resource "aws_flow_log" "vpc_flow_logs" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-vpc-flow-logs-${var.environment}"
    }
  )
}

# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flowlogs/${var.project_name}-${var.environment}"
  retention_in_days = 7

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-flow-logs-group-${var.environment}"
    }
  )
}

# IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "${var.project_name}-vpc-flow-logs-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for VPC Flow Logs
resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "${var.project_name}-vpc-flow-logs-policy-${var.environment}"
  role = aws_iam_role.vpc_flow_logs_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# VPC Endpoints (optional but recommended for cost optimization)
# S3 Gateway Endpoint - No data transfer charges
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  route_table_ids = [] # Will be populated in routing module

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-s3-endpoint-${var.environment}"
    }
  )
}

# DynamoDB Gateway Endpoint - No data transfer charges
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.dynamodb"

  route_table_ids = [] # Will be populated in routing module

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-dynamodb-endpoint-${var.environment}"
    }
  )
}

# Enable VPC DNS Resolution
resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "ec2.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-dhcp-options-${var.environment}"
    }
  )
}

# Associate DHCP Options with VPC
resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}
