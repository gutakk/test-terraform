variable "namespace" {
  type = string
}

variable "aws_ecr_repository_url" {
  description = "Amazon ECR repository URL"
}

variable "alb_target_group_arn" {
  description = "ALB target group ARN"
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "desired_count" {
  type = number
}

variable "owner" {
  type = string
}

variable "asg_arn" {
  type = string
}
