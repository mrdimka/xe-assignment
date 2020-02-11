variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "public_key_path" {
}

variable "key_name" {
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

# Specify the provider and access details
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

