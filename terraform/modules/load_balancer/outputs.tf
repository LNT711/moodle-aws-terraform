output "lb_dns_name" {
  value = aws_lb.app_lb.dns_name
}
output "target_group_arn" {
  description = "ARN del Target Group"
  value       = aws_lb_target_group.app_tg.arn
}
