resource "aws_iam_role" "task_role" {
  name = "${local.prefix}-taskrole"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = ["ecs.application-autoscaling.amazonaws.com", "ecs-tasks.amazonaws.com"]
          AWS     = data.terraform_remote_state.ecs.outputs.iamrole_ecs_exec_arn
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "allow_assume" {
  name = "allow-assume"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Effect = "Allow", Action = "sts:AssumeRole", Resource = "*" }]
  })
}

resource "aws_iam_role_policy" "logs_policy" {
  name = "logs"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = aws_cloudwatch_log_group.logs.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "exec_policy" {
  name = "exec"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}
