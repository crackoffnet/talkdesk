variable "region" {}
variable "env" {
  description = "env: dr, qa or prod"
}

variable "cidr_block" {}
variable "private_subnets" {}
variable "public_subnets" {}
variable "availability_zones" {}
variable "tags" {}
variable "public_subnet_tags" {}
variable "private_subnet_tags" {}