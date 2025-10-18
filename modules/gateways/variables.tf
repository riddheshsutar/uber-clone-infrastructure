# modules/gateways/variables.tf

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Use single NAT gateway for all AZs (cost optimization)"
  type        = bool
  default     = false
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to gateway resources"
  type        = map(string)
  default     = {}
}
