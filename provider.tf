terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"

  backend "s3" {
    bucket = "task09-cmba-s3bucket"
    key    = "tf_lambda_state/terraform.tfstate"
    region = "eu-central-1"
  }
}



provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}
