variable "subnet_ids" {
  description = "Subnets for mount targets"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID del Security Group que permite acceso a EFS"
  type        = string
}