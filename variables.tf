
variable "suffix" {
  type        = string
  description = "task and my name to use for resource names."
  default     = "task15_cmba"
}

variable "lambda_SG" {
  type        = list(string)
  description = "security group for lambda."
  default     = ["sg-079c1208b292b93ff"]
}


variable "lambda_subnets" {
  type        = list(string)
  description = "subnets for lambda."
  default     = ["subnet-04d9ba157b61c1802" , "subnet-0c98e1819f7381e46"]
}

