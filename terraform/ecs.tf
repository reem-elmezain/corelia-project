########################################
# ECS Cluster
########################################

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

########################################
# ECS Task Definitions
########################################

# USER SERVICE
resource "aws_ecs_task_definition" "user_task" {
  family                   = "${var.project_name}-user-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "user-container"
    image = var.user_service_image
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
      protocol      = "tcp"
    }]
  }])
}

# ORDER SERVICE
resource "aws_ecs_task_definition" "order_task" {
  family                   = "${var.project_name}-order-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "order-container"
    image = var.order_service_image
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
      protocol      = "tcp"
    }]
  }])
}

# PAYMENT SERVICE
resource "aws_ecs_task_definition" "payment_task" {
  family                   = "${var.project_name}-payment-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "payment-container"
    image = var.payment_service_image
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
      protocol      = "tcp"
    }]
  }])
}

########################################
# Security Group for ECS Tasks
########################################

resource "aws_security_group" "ecs_tasks_sg" {
  name        = "${var.project_name}-ecs-tasks-sg"
  description = "Allow traffic from ALB to ECS tasks"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ecs-tasks-sg"
  }
}



########################################
# ECS Services
########################################

# USER SERVICE
resource "aws_ecs_service" "user_service" {
  name            = "${var.project_name}-user-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.user_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    subnets          = aws_subnet.private_subnets[*].id
    assign_public_ip = false
  }

 load_balancer {
  target_group_arn = aws_lb_target_group.user_tg.arn
  container_name   = "user-container"
  container_port   = 3000
}

  depends_on = [
  aws_lb_listener.http_listener,
  aws_lb_listener_rule.user_rule
]
}

# ORDER SERVICE
resource "aws_ecs_service" "order_service" {
  name            = "${var.project_name}-order-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.order_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    subnets          = aws_subnet.private_subnets[*].id
    assign_public_ip = false
  }

  load_balancer {
  target_group_arn = aws_lb_target_group.order_tg.arn
  container_name   = "order-container"
  container_port   = 3000
}
  depends_on = [
  aws_lb_listener.http_listener,
  aws_lb_listener_rule.order_rule
]
}

# PAYMENT SERVICE
resource "aws_ecs_service" "payment_service" {
  name            = "${var.project_name}-payment-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.payment_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    subnets          = aws_subnet.private_subnets[*].id
    assign_public_ip = false
  }

  load_balancer {
  target_group_arn = aws_lb_target_group.payment_tg.arn
  container_name   = "payment-container"
  container_port   = 3000
}

  depends_on = [
  aws_lb_listener.http_listener,
  aws_lb_listener_rule.payment_rule
]
}