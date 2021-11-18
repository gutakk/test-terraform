variable "namespace" {
  type = string
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the LB"
  type        = list(any)
}

variable "security_group_ids" {
  description = "A list of security group IDs to assign to the LB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "owner" {
  type = string
}
