resource "aws_db_subnet_group" "moodle" {
  name       = "moodle-subnet-group"
  subnet_ids = [var.private_subnet_id]
}

resource "aws_db_instance" "moodle" {
  identifier              = "moodle-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_name                 = "moodledb"
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [var.security_group_id]
  db_subnet_group_name    = aws_db_subnet_group.moodle.name
}
