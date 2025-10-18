# modules/gateways/main.tf

# ========================================
# INTERNET GATEWAY
# ========================================

# Internet Gateway - Allows communication between VPC and internet
resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-igw-${var.environment}"
    }
  )
}

# ========================================
# ELASTIC IPs FOR NAT GATEWAYS
# ========================================

# Create Elastic IPs for NAT Gateways
# Using one per AZ for high availability (or single for cost optimization)
resource "aws_eip" "nat" {
  count  = var.single_nat_gateway ? 1 : length(var.availability_zones)
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-eip-nat-${var.environment}-${count.index + 1}"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

# ========================================
# NAT GATEWAYS
# ========================================

# NAT Gateways - Allow private subnets to access internet (outbound only)
resource "aws_nat_gateway" "main" {
  count         = var.single_nat_gateway ? 1 : length(var.availability_zones)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-nat-gw-${var.environment}-${count.index + 1}"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

# ========================================
# VPC FLOW LOGS FOR GATEWAYS (Optional but recommended)
# ========================================

# CloudWatch Log Group for NAT Gateway Flow Logs
resource "aws_cloudwatch_log_group" "nat_flow_logs" {
  name              = "/aws/nat-gateway/${var.project_name}-${var.environment}"
  retention_in_days = 7

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-nat-flow-logs-${var.environment}"
    }
  )
}

# IAM Role for NAT Gateway Flow Logs
resource "aws_iam_role" "nat_flow_logs_role" {
  name = "${var.project_name}-nat-flow-logs-role-${var.environment}"

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

# IAM Policy for NAT Gateway Flow Logs
resource "aws_iam_role_policy" "nat_flow_logs_policy" {
  name = "${var.project_name}-nat-flow-logs-policy-${var.environment}"
  role = aws_iam_role.nat_flow_logs_role.id
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

# ========================================
# LOCAL VARIABLES FOR GATEWAY INFO
# ========================================

locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : length(var.availability_zones)
  nat_gateways_map = {
    for idx, nat in aws_nat_gateway.main :
    idx => {
      id            = nat.id
      public_ip     = aws_eip.nat[idx].public_ip
      subnet_id     = nat.subnet_id
      allocation_id = nat.allocation_id
    }
  }
}
