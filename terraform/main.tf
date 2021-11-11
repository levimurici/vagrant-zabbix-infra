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
      if ! ``docker --version > /dev/null 2>&1`` ; then 
        sudo curl -sSL https://get.docker.com/ | sh;
        sudo usermod -aG docker `echo $USER`;
        sudo setfacl -m user:`echo $USER`:rw /var/run/docker.sock
      fi
      sleep 3;
      sudo apt-get install -y python3 python3-pip;
      sudo apt install -y docker-compose;
      sudo apt install -y git;
      
      sleep 3; 
      cd ~;
      git clone https://github.com/levimurici/suricato-iot && cd suricato-iot;
      docker-compose up -d;
      fi;
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
    vpc_security_group_ids = ["${aws_security_group.acesso-dnd.id}"]
    
    network_interface {
      network_interface_id = aws_network_interface.interface-1.id
      device_index         = 1
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

# Create a VPC
resource "aws_vpc" "dnd_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "dnd_vpc"
  }
}

resource "aws_subnet" "dnd_subnet" {
  vpc_id            = aws_vpc.dnd_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "dnd_subnet"
  }
}

resource "aws_network_interface" "interface-1" {
  subnet_id   = aws_subnet.dnd_subnet.id
  private_ips = ["10.0.10.1", "10.0.10.1"]

  tags = {
    Name = "primary_network_interface"
  }
}