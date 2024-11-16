# AWS Region where resources will be deployed
variable "aws_region" {
  type        = string
  description = "AWS Region to deploy resources"
  default     = "ca-central-1"
}