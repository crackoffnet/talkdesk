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

