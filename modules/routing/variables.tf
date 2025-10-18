# modules/routing/variables.tf

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "db_subnet_ids" {
  description = "List of database subnet IDs"
  type        = list(string)
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID"
  type        = string
}

variable "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  type        = list(string)
}

variable "s3_endpoint_id" {
  description = "S3 VPC Endpoint ID"
  type        = string
}

variable "dynamodb_endpoint_id" {
  description = "DynamoDB VPC Endpoint ID"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Using single NAT gateway for all AZs"
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
  description = "Tags to apply to routing resources"
  type        = map(string)
  default     = {}
}
