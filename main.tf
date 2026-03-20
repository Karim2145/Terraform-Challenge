terraform {
    required_providers {
        aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.my_region
}

# == VPC ==
resource "aws_vpc" "Lab7_VPC" {
    cidr_block = var.VPC_Cidr_Block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "Lab7-VPC"
    }
}
