# Configure the AWS Provider
provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
}

# Instância que irá rodar os microserviços em docker-compose
resource "aws_instance" "services" {
    depends_on = [aws_s3_bucket.dump-services]
    count = 1
    ami = var.amis["ami-services"] # Ubuntu 20.1 LTS x86
    instance_type = "t2.micro"
    key_name = var.key_name["keyname-services"]
    tags = {
      Name = "Serviços-${count.index}"
    }
    vpc_security_group_ids = ["${aws_security_group.acesso-dnd.id}"]

    network_interface {
      network_interface_id = aws_network_interface.interface-1.id
      device_index         = 0
    }

  provisioner "local-exec" {
    working_dir = "/tmp"
    command     = <<EOT
      sudo apt install -y git;
      cd ~;
      git clone https://github.com/levimurici/dnd-initial-scripts && cd dnd-initial-scripts;
      chmod +x docker-suricato.sh && sudo ./docker-surcicato.sh
    EOT
  }
}

resource "aws_instance" "zabbix" {
    count = 1
    ami = var.amis["ami-services"] # Ubuntu 20.1 LTS x86
    instance_type = "t2.micro"
    key_name = var.key_name["keyname-services"]
    tags = {
      Name = "Zabbix-server"
    }
    /* vpc_security_group_ids = ["${aws_security_group.acesso-dnd.id}"] */
    
    network_interface {
      network_interface_id = aws_network_interface.interface-2.id
      device_index         = 0
    }
}

resource "aws_s3_bucket" "dump-services" {
  bucket = "suricato-dump-services"
  acl    = "private" # Permissionamento, no caso privado

  tags = {
    Name        = "suricato-dump-services"
    Environment = "Dev"
  }
}