
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
  private_ips = ["10.0.10.101"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_network_interface" "interface-2" {
  subnet_id   = aws_subnet.dnd_subnet.id
  private_ips = ["10.0.10.111"]

  tags = {
    Name = "primary_network_interface"
  }
}
