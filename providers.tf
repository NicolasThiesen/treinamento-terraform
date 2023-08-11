terraform {
  backend "s3" {
    bucket = "nicolas-terraform-2342344"
    key = "infra/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.11.0"
    }

  }
  required_version = "~>1.5.4"

}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      criador = var.user
      Name    = var.user
    }
  }
}
