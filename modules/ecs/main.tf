resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.name}-cluster"
}

resource "aws_iam_role" "task_execution_role" {
  name = "${var.name}-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "execution_role_policy_attach" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "${var.name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = var.container_image_url
      essential = true
      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.name}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app_service" {
  name            = "${var.name}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true
    security_groups  = [aws_security_group.fargate_sg.id]
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app" # must match ECS task def container
    container_port   = 8000
  }

  depends_on = [aws_iam_role.task_execution_role,
  var.alb_target_group_arn]
}

resource "aws_security_group" "fargate_sg" {
  name        = "${var.name}-fargate-sg"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "agent_runner_logs" {
  name              = "/ecs/agent-runner"
  retention_in_days = 7
}



