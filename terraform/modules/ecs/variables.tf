variable "docker_image" {}
variable "db_host" {}
variable "db_user" {}
variable "db_password" {}

#variable "public_subnet_ids" {
 # type = list(string)
#}
variable "security_group_id" {}
variable "target_group_arn" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "efs_id" {
  type = string
}