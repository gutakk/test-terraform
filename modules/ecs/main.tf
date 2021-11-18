data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_task_execution_ssm" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.namespace}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_ssm_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_ssm.arn
}

resource "aws_ecs_cluster" "main" {
  name = "${var.namespace}-ecs-cluster"

  tags = {
    Owner = var.owner
  }
}

resource "aws_ecs_task_definition" "main" {
  cpu                   = var.cpu
  memory                = var.memory
  family                = "${var.namespace}-service"
  network_mode          = "bridge"
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = file("service.json")

  tags = {
    Owner = var.owner
  }
}

resource "aws_ecs_service" "main" {
  name            = "${var.namespace}-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  launch_type     = "EC2"
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.main.arn

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.namespace
    container_port   = 80
  }

  tags = {
    Owner = var.owner
  }
}
