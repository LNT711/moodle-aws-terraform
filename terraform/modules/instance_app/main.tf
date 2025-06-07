resource "aws_instance" "nodejs_server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

  tags = {
    Name = "NodeJS-App-Server"
  }
}
resource "aws_lb_target_group_attachment" "nodejs_attachment" {
  target_group_arn = var.target_group_arn 
  target_id        = aws_instance.nodejs_server.id
  port            = 4000
}


