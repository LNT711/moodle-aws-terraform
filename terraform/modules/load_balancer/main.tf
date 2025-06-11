resource "aws_lb" "app_lb" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "app_tg" {
  name        = "app-target-group"
  port        = 8080                          
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"                         

  health_check {
    path                = "/"
    port                = "traffic-port"
    matcher             = "200-399"
    interval            = 60
    timeout             = 20
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
