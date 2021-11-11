# Configure the AWS Provider
provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
}

# Instância que irá rodar os microserviços em docker-compose
resource "aws_instance" "services" {
    count = 1
    ami = var.amis["ami-services"] # Ubuntu 20.1 LTS x86
    instance_type = "t2.micro"
    key_name = var.key_name["keyname-services"]
    tags = {
      Name = "Serviços-${count.index}"
    }
    vpc_security_group_ids = ["${aws_security_group.acesso-dnd.id}"]
    depends_on = [aws_s3_bucket.dump-services]

/*     provisioner "local-exec" {
      working_dir = "/tmp"
      command     = <<EOT
        if ! ``docker --version > /dev/null 2>&1`` ; then 
          sudo curl -sSL https://get.docker.com/ | sh;
          sudo usermod -aG docker `echo $USER`;
          sudo setfacl -m user:`echo $USER`:rw /var/run/docker.sock
        fi
    EOT
  } */
}

resource "aws_instance" "zabbix" {
    count = 1
    ami = var.amis["ami-services"] # Ubuntu 20.1 LTS x86
    instance_type = "t2.micro"
    key_name = var.key_name["keyname-services"]
    tags = {
      Name = "Zabbix-server"
    }
    vpc_security_group_ids = ["${aws_security_group.acesso-dnd.id}"]
}

resource "aws_s3_bucket" "dump-services" {
  bucket = "suricato-dump-services"
  acl    = "private" # Permissionamento, no caso privado

  tags = {
    Name        = "suricato-dump-services"
    Environment = "Dev"
  }
}

/* # Create a VPC
resource "aws_vpc" "dnd_vpc" {
  cidr_block = "10.0.0.0/16"
} */