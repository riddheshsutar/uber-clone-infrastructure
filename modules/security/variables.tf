# modules/security/variables.tf

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# Port Variables
variable "app_port" {
  description = "Application server port"
  type        = number
  default     = 8080
}

variable "cache_port" {
  description = "Cache layer port (Redis: 6379, Memcached: 11211)"
  type        = number
  default     = 6379
}

variable "db_port" {
  description = "Database port (MySQL: 3306, PostgreSQL: 5432)"
  type        = number
  default     = 3306
}

# CIDR Blocks for Access Control
variable "bastion_cidr_block" {
  description = "CIDR block for bastion/admin access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Tags to apply to security group resources"
  type        = map(string)
  default     = {}
}
