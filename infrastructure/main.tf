terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }
  #   backend "s3" {
  #     bucket         	   = "glpi-remote-state"
  #     key                = "state/terraform.tfstate"
  #     region         	   = "us-east-1"
  #     encrypt        	   = true    
  # }
}

provider "aws" {
  region  = var.region
  profile = "default"
  default_tags {
    tags = {
      "owner"      = var.autor
      "project"    = var.workshop
      "customer"   = var.customer
      "managed_by" = var.automation
    }
  }
}