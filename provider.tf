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
  region  = "sa-east-1"
  profile = "tf-mentor"
}
