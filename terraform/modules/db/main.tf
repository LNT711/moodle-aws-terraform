resource "aws_instance" "mongodb_server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

  tags = {
    Name = "MongoDB-Server"
  }
}
