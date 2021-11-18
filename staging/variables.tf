variable "app_name" {
  description = "App Name"
  default     = "test-terraform"
}

variable "region" {
  default = "ap-southeast-1"
}

variable "owner" {
  default = "test-terraform"
}

variable "environment" {
  default = "staging"
}

variable "ecs_cpu" {
  default = 512
}

variable "ecs_memory" {
  default = 1024
}

variable "ecs_desired_count" {
  default = 1
}
