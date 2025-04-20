resource "aws_alb" "alb" {
  load_balancer_type         = "application"
  name                       = "${local.prefix}-alb"
  subnets                    = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  security_groups            = [aws_security_group.lb.id]
  idle_timeout               = 120
  enable_deletion_protection = false
  drop_invalid_header_fields = false
  enable_http2               = true
  ip_address_type            = "ipv4"
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    order            = 1
    target_group_arn = aws_alb_target_group.tg.arn
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type  = "redirect"
    order = 1

    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_target_group" "tg" {
  name                          = "${local.prefix}-tg"
  port                          = 3000
  protocol                      = "HTTP"
  vpc_id                        = data.terraform_remote_state.vpc.outputs.vpc.id
  target_type                   = "ip"
  load_balancing_algorithm_type = "round_robin"
  proxy_protocol_v2             = false
  deregistration_delay          = 60

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    path                = "/api/health"
    matcher             = "200-299"
    port                = 3000
    protocol            = "HTTP"
  }

  stickiness {
    enabled         = false
    type            = "lb_cookie"
    cookie_duration = 86400
  }
}
