output "alb_security_group_ids" {
  description = "Security group IDs for ALB"
  value       = [aws_security_group.alb.id]
}

output "ec2_security_group_ids" {
  description = "Security group IDs for EC2"
  value       = [aws_security_group.ec2.id]
}
