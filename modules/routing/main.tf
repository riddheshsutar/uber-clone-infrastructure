# modules/routing/main.tf

# ========================================
# PUBLIC ROUTE TABLE
# ========================================

# Create public route table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-rt-${var.environment}"
      Type = "Public"
    }
  )
}

# Route: Public subnet traffic to Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# ========================================
# PRIVATE ROUTE TABLES
# ========================================

# Create private route tables (one per AZ for high availability)
resource "aws_route_table" "private" {
  count  = var.single_nat_gateway ? 1 : length(var.availability_zones)
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-rt-${var.environment}-${count.index + 1}"
      Type = "Private"
    }
  )
}

# Route: Private subnet traffic to NAT Gateway
resource "aws_route" "private_nat_gateway" {
  count                  = var.single_nat_gateway ? 1 : length(var.availability_zones)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[count.index]
}

# Associate private subnets with private route tables
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = var.single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
}

# ========================================
# DATABASE ROUTE TABLE
# ========================================

# Create database route table
resource "aws_route_table" "database" {
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-database-rt-${var.environment}"
      Type = "Database"
    }
  )
}

# Route: Database subnet to private subnet (no direct internet route)
# Databases will be isolated - no outbound internet access by default
# Uncomment below if you need database servers to access internet through NAT
/*
resource "aws_route" "database_nat_gateway" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[0]
}
*/

# Associate database subnets with database route table
resource "aws_route_table_association" "database" {
  count          = length(var.db_subnet_ids)
  subnet_id      = var.db_subnet_ids[count.index]
  route_table_id = aws_route_table.database.id
}

# ========================================
# VPC ENDPOINT ROUTE TABLE ASSOCIATIONS
# ========================================

# S3 Endpoint Association - Public Route Table
resource "aws_vpc_endpoint_route_table_association" "s3_public" {
  route_table_id  = aws_route_table.public.id
  vpc_endpoint_id = var.s3_endpoint_id
}

# S3 Endpoint Association - Private Route Tables
resource "aws_vpc_endpoint_route_table_association" "s3_private" {
  count           = var.single_nat_gateway ? 1 : length(var.availability_zones)
  route_table_id  = aws_route_table.private[count.index].id
  vpc_endpoint_id = var.s3_endpoint_id
}

# S3 Endpoint Association - Database Route Table
resource "aws_vpc_endpoint_route_table_association" "s3_database" {
  route_table_id  = aws_route_table.database.id
  vpc_endpoint_id = var.s3_endpoint_id
}

# DynamoDB Endpoint Association - Public Route Table
resource "aws_vpc_endpoint_route_table_association" "dynamodb_public" {
  route_table_id  = aws_route_table.public.id
  vpc_endpoint_id = var.dynamodb_endpoint_id
}

# DynamoDB Endpoint Association - Private Route Tables
resource "aws_vpc_endpoint_route_table_association" "dynamodb_private" {
  count           = var.single_nat_gateway ? 1 : length(var.availability_zones)
  route_table_id  = aws_route_table.private[count.index].id
  vpc_endpoint_id = var.dynamodb_endpoint_id
}

# DynamoDB Endpoint Association - Database Route Table
resource "aws_vpc_endpoint_route_table_association" "dynamodb_database" {
  route_table_id  = aws_route_table.database.id
  vpc_endpoint_id = var.dynamodb_endpoint_id
}

# ========================================
# LOCAL VARIABLES FOR ROUTING INFO
# ========================================

locals {
  route_tables_summary = {
    public = {
      id      = aws_route_table.public.id
      routes  = "0.0.0.0/0 → IGW"
      subnets = length(var.public_subnet_ids)
    }
    private = {
      count   = length(aws_route_table.private)
      routes  = "0.0.0.0/0 → NAT"
      subnets = length(var.private_subnet_ids)
    }
    database = {
      id      = aws_route_table.database.id
      routes  = "Internal VPC only"
      subnets = length(var.db_subnet_ids)
    }
  }
}
