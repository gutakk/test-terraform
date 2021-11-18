output "alb_security_group_ids" {
  description = "Security group IDs for ALB"
  value       = [aws_security_group.alb.id]
}
