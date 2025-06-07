variable "ami" {
  description = "AMI ID de la instancia"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
}

variable "key_name" {
  description = "Clave SSH para la instancia"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subnet donde se desplegará la instancia"
  type        = string
}

variable "security_group_id" {
  description = "ID del Security Group asignado"
  type        = string
}

variable "target_group_arn" {
  description = "ARN del Target Group del Load Balancer"
  type        = string
}

