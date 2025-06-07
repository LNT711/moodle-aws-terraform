variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "security_group_id" {
  description = "ID del Security Group para el Load Balancer"
  type        = string
}

variable "public_subnet_ids" {
  description = "Lista de subnets públicas en diferentes AZs para el Load Balancer"
  type        = list(string)
}
