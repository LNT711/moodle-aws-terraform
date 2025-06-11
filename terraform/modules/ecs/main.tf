resource "aws_ecs_cluster" "moodle" {
  name = "moodle-cluster"
}

resource "aws_ecs_task_definition" "moodle" {
  family                   = "moodle-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  
  container_definitions = jsonencode([{
    name      = "moodle"
    image     = var.docker_image
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
    environment = [
      { name = "DB_HOST", value = var.db_host },
      { name = "DB_USER", value = var.db_user },
      { name = "DB_PASSWORD", value = var.db_password }
    ]
  }])
}

resource "aws_ecs_service" "moodle" {
  name            = "moodle-service"
  cluster         = aws_ecs_cluster.moodle.id
  task_definition = aws_ecs_task_definition.moodle.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    #subnets          = var.public_subnet_ids
    subnets           = var.private_subnet_ids
    security_groups  = [var.security_group_id]
    #assign_public_ip = true
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "moodle"
    container_port   = 8080
  }
}
