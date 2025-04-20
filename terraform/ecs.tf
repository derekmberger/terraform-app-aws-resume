# resource "aws_ecr_repository" "ecr_repo" {
#   name = var.service_name
#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }

resource "aws_ecs_service" "service" {
  name                               = local.prefix
  cluster                            = data.terraform_remote_state.ecs.outputs.ecs_cluster_id
  task_definition                    = aws_ecs_task_definition.task_def.arn
  desired_count                      = 0
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  propagate_tags                     = "SERVICE"
  scheduling_strategy                = "REPLICA"
  enable_ecs_managed_tags            = true
  health_check_grace_period_seconds  = 5
  enable_execute_command             = true

  network_configuration {
    security_groups = [aws_security_group.service.id]
    subnets         = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.tg.arn
    container_name   = var.service_name
    container_port   = 3000
  }

  capacity_provider_strategy {
    capacity_provider = data.terraform_remote_state.ecs.outputs.ecs_capacity_provider_name
    weight            = 1
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = false
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count,
    ]
  }

  depends_on = [
    aws_ecs_task_definition.task_def,
    aws_alb_target_group.tg,
  ]
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = local.prefix
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = 1024
  memory                   = 960
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = data.terraform_remote_state.ecs.outputs.iamrole_ecs_exec_arn

  container_definitions = jsonencode([
    {
      name      = var.service_name
      command   = ["/bin/sh", "-c", "npx next start -p 3000"]
      essential = true
      image     = "${aws_ecr_repository.ecr_repo.repository_url}:dev"
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      linuxParameters = { initProcessEnabled = true }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = aws_cloudwatch_log_group.logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/logs/${var.environment}/${var.service_name}"
  retention_in_days = 14
}
