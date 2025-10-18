# modules/subnets/main.tf
# Public Subnets - Accessible from internet
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-subnet-${var.environment}-${count.index + 1}"
      Type = "Public"
    }
  )
}

# Private Subnets - Not directly accessible from internet (for application servers)
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-subnet-${var.environment}-${count.index + 1}"
      Type = "Private"
    }
  )
}

# Database Subnets - Private subnets for RDS databases
resource "aws_subnet" "database" {
  count             = length(var.db_subnet_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-db-subnet-${var.environment}-${count.index + 1}"
      Type = "Database"
    }
  )
}

# DB Subnet Group - Required for RDS deployment
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group-${var.environment}"
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-db-subnet-group-${var.environment}"
    }
  )
}

# Network ACLs for additional security layer (optional but recommended)
# Public Network ACL
resource "aws_network_acl" "public" {
  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.public[*].id

  # Allow inbound HTTP
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # Allow inbound HTTPS
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Allow inbound SSH (restricted to specific IPs in production)
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  # Allow ephemeral ports for return traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Allow all outbound traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-nacl-${var.environment}"
    }
  )
}

# Private Network ACL
resource "aws_network_acl" "private" {
  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.private[*].id

  # Allow inbound from VPC CIDR
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr_block
    from_port  = 0
    to_port    = 0
  }

  # Allow ephemeral ports from internet
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Allow all outbound traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-nacl-${var.environment}"
    }
  )
}

# Database Network ACL
resource "aws_network_acl" "database" {
  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.database[*].id

  # Allow inbound from VPC CIDR (private subnets for database access)
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr_block
    from_port  = 0
    to_port    = 0
  }

  # Allow all outbound traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-database-nacl-${var.environment}"
    }
  )
}
