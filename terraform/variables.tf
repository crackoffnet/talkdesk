variable "env" {
  type        = string
  description = "Options: dr, qa, prod"
}

variable "region" {
  type      = map(any)
  sensitive = true
  default = {
    dr   = "us-west-1"
    qa   = "us-east-1"
    prod = "us-east-1"
  }
}

variable "cluster_names" {
  description = "Names of the EKS clusters deployed in this VPC."
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "Names of the EKS clusters deployed in this VPC."

  default = []
}
variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}