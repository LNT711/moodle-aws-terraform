resource "aws_ecs_cluster" "moodle" {
  name = "moodle-cluster"
}

resource "aws_ecs_task_definition" "moodle" {
  family                   = "moodle-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = "arn:aws:iam::043784813520:role/LabRole"
  
  container_definitions = jsonencode([{
    name      = "moodle"
    image     = var.docker_image
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
      protocol = "tcp"
    }]
    logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/moodle"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }

      #mountPoints = [
     # {
      #  sourceVolume  = "moodle-volume",
      #  containerPath = "/bitnami/moodle"
      #},
      #{
        #sourceVolume  = "moodledata-volume"
        #containerPath = "/bitnami/moodledata"
      #}
    #]


    environment = [
      { name = "MOODLE_DATABASE_HOST", value = var.db_host },
      { name = "MOODLE_DATABASE_PORT_NUMBER", value = "3306" },
      { name = "MOODLE_DATABASE_USER", value = var.db_user },
      { name = "MOODLE_DATABASE_PASSWORD", value = var.db_password },
      { name = "MOODLE_DATABASE_NAME", value = "moodledb" },
      { name = "MOODLE_USERNAME", value = "admin" },
      { name = "MOODLE_PASSWORD", value = "adminpass" },
      { name = "MOODLE_EMAIL", value = "admin@moodle.com" },
      { name = "MOODLE_SKIP_BOOTSTRAP", value = "no" },
      { name = "BITNAMI_DEBUG", value = "true" },
      { name = "MOODLE_SKIP_INSTALL", value = "no" }
    ]
  }])

  #volume {
  #  name = "moodle-volume"
  #}
  
  #volume {
   # name = "moodledata-volume"
  #}

}



resource "aws_cloudwatch_log_group" "moodle" {
  name              = "/ecs/moodle"
  retention_in_days = 7
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
