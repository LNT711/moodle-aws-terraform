resource "aws_db_subnet_group" "moodle" {
  name       = "moodle-subnet-group"
 subnet_ids = var.private_subnet_ids
}


resource "aws_db_parameter_group" "moodle" {
  name        = "moodle-parameter-group"
  family      = "mariadb10.6" 
  description = "Custom parameter group for Moodle DB"

  parameter {
    name  = "innodb_file_per_table"
    value = "1"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }
}


resource "aws_db_instance" "moodle" {
  identifier              = "moodle-db"
  engine                  = "mariadb"
  engine_version          = "10.6.16"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_name                 = "moodledb"
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [var.security_group_id]
  db_subnet_group_name    = aws_db_subnet_group.moodle.name
  parameter_group_name    = aws_db_parameter_group.moodle.name
}
