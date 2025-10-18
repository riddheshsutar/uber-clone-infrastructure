# AWS Region
variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "ap-south-1"
}

# Project Name
variable "project_name" {
  description = "Project name for tagging and naming resources"
  type        = string
  default     = "uber-clone"

  validation {
    condition     = length(var.project_name) <= 20
    error_message = "Project name must be 20 characters or less."
  }
}

# Environment
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = "VPC CIDR block must be a valid CIDR notation."
  }
}

# Enable DNS Hostnames
variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in VPC"
  type        = bool
  default     = true
}

# Enable DNS Support
variable "enable_dns_support" {
  description = "Enable DNS support in VPC"
  type        = bool
  default     = true
}

# Availability Zones
variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

# Public Subnet CIDR Blocks
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# Private Subnet CIDR Blocks
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

# Database Subnet CIDR Blocks
variable "db_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

# Enable NAT Gateway
variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

# Single NAT Gateway for Cost Optimization
variable "single_nat_gateway" {
  description = "Use single NAT gateway for all AZs (cost optimization)"
  type        = bool
  default     = false
}

# RDS Configuration
variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "uberdb"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "uberadmin"
  sensitive   = true
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "db_storage" {
  description = "RDS storage in GB"
  type        = number
  default     = 20
}

variable "db_backup_retention" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

# Tags
variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
