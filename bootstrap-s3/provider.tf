terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.65"
    }
  }
  required_version = ">= 1.4.6"
}

provider "aws" {
  region  = "us-east-1"
  profile = "tf-mentor"
  default_tags {
    tags = {
      "Terraformed" = "true"
    }
  }
}
