# Configure the AWS Provider
provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
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
    vpc_security_group_ids = ["${aws_security_group.acesso-dnd.id}"]
}

resource "aws_security_group" "acesso-dnd" {
  name        = "acesso-dnd"
  description = "acesso do lab"

  ingress  {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["177.50.229.182/32"]
    }

  tags = {
    Name = "ssh"
  }
}

resource "aws_s3_bucket" "dump-services" {
  bucket = "suricato-dump-services"
  acl    = "private" // Permissionamento, no caso privado

  tags = {
    Name        = "suricato-dump-services"
    Environment = "Dev"
  }
}

/* # Create a VPC
resource "aws_vpc" "dnd_vpc" {
  cidr_block = "10.0.0.0/16"
} */