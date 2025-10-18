# modules/security/main.tf

# ========================================
# LOAD BALANCER SECURITY GROUP
# ========================================

resource "aws_security_group" "load_balancer" {
  name        = "${var.project_name}-alb-sg-${var.environment}"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-alb-sg-${var.environment}"
    }
  )
}

# Allow HTTP from internet
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.load_balancer.id
  description       = "Allow HTTP from internet"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-alb-http-rule"
  }
}

# Allow HTTPS from internet
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.load_balancer.id
  description       = "Allow HTTPS from internet"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-alb-https-rule"
  }
}

# Allow all outbound traffic from ALB
resource "aws_vpc_security_group_egress_rule" "alb_all_outbound" {
  security_group_id = aws_security_group.load_balancer.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-alb-all-outbound"
  }
}

# ========================================
# APPLICATION SECURITY GROUP
# ========================================

resource "aws_security_group" "application" {
  name        = "${var.project_name}-app-sg-${var.environment}"
  description = "Security group for Application Servers"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-app-sg-${var.environment}"
    }
  )
}

# Allow traffic from ALB on application port
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.application.id
  description                  = "Allow traffic from ALB"
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.load_balancer.id

  tags = {
    Name = "${var.project_name}-app-from-alb"
  }
}

# Allow SSH from bastion/admin security group (for debugging)
resource "aws_vpc_security_group_ingress_rule" "app_ssh_from_bastion" {
  security_group_id = aws_security_group.application.id
  description       = "Allow SSH from bastion host"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.bastion_cidr_block

  tags = {
    Name = "${var.project_name}-app-ssh-bastion"
  }
}

# Allow all outbound traffic from application servers
resource "aws_vpc_security_group_egress_rule" "app_all_outbound" {
  security_group_id = aws_security_group.application.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-app-all-outbound"
  }
}

# ========================================
# CACHE SECURITY GROUP (Redis/Memcached)
# ========================================

resource "aws_security_group" "cache" {
  name        = "${var.project_name}-cache-sg-${var.environment}"
  description = "Security group for Cache Layer (Redis/Memcached)"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-cache-sg-${var.environment}"
    }
  )
}

# Allow Redis/Memcached from application servers
resource "aws_vpc_security_group_ingress_rule" "cache_from_app" {
  security_group_id            = aws_security_group.cache.id
  description                  = "Allow cache traffic from application servers"
  from_port                    = var.cache_port
  to_port                      = var.cache_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.application.id

  tags = {
    Name = "${var.project_name}-cache-from-app"
  }
}

# Allow all outbound traffic from cache
resource "aws_vpc_security_group_egress_rule" "cache_all_outbound" {
  security_group_id = aws_security_group.cache.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-cache-all-outbound"
  }
}

# ========================================
# DATABASE SECURITY GROUP
# ========================================

resource "aws_security_group" "database" {
  name        = "${var.project_name}-db-sg-${var.environment}"
  description = "Security group for RDS Database"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-db-sg-${var.environment}"
    }
  )
}

# Allow MySQL/Aurora traffic from application servers
resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.database.id
  description                  = "Allow database traffic from application servers"
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.application.id

  tags = {
    Name = "${var.project_name}-db-from-app"
  }
}

# Allow database traffic from other database instances (read replicas)
resource "aws_vpc_security_group_ingress_rule" "db_from_db" {
  security_group_id            = aws_security_group.database.id
  description                  = "Allow database traffic between DB instances"
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.database.id

  tags = {
    Name = "${var.project_name}-db-from-db"
  }
}

# Deny all outbound traffic by default (restrictive approach)
# Uncomment if you want complete isolation
/*
resource "aws_vpc_security_group_egress_rule" "db_deny_all" {
  security_group_id = aws_security_group.database.id
  description       = "Deny all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
}
*/

# ========================================
# SECURITY GROUP FOR SELF-REFERENCE (Inter-module communication)
# ========================================

resource "aws_security_group" "internal" {
  name        = "${var.project_name}-internal-sg-${var.environment}"
  description = "Security group for internal VPC communication"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-internal-sg-${var.environment}"
    }
  )
}

# Allow all traffic from within the same security group
resource "aws_vpc_security_group_ingress_rule" "internal_self" {
  security_group_id            = aws_security_group.internal.id
  description                  = "Allow all traffic from same security group"
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.internal.id

  tags = {
    Name = "${var.project_name}-internal-self-traffic"
  }
}

# Allow all traffic from VPC CIDR
resource "aws_vpc_security_group_ingress_rule" "internal_vpc" {
  security_group_id = aws_security_group.internal.id
  description       = "Allow all traffic from VPC CIDR"
  ip_protocol       = "-1"
  cidr_ipv4         = var.vpc_cidr_block

  tags = {
    Name = "${var.project_name}-internal-vpc-traffic"
  }
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "internal_all_outbound" {
  security_group_id = aws_security_group.internal.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-internal-all-outbound"
  }
}
