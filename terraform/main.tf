/* terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
 */

# Configure the AWS Provider
provider "aws" {
    version = "~> 3.0"
    region = "us-east-1"
}

//Instância que irá rodar os microserviços em docker-compose
resource "aws_instance" "services" {
    count = 1
    ami = "ami-083654bd07b5da81d" // Ubuntu 20.1 LTS x86
    instance_type = "t2.micro"
    key_name = "terraform-aws-dnd-devops-labs"
    tags = {
      Name = "Serviços-${count.index}"
    }
}

/* # Create a VPC
resource "aws_vpc" "dnd_vpc" {
  cidr_block = "10.0.0.0/16"
} */