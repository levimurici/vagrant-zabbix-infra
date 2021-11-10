resource "aws_security_group" "acesso-dnd" {
  name        = "acesso-dnd"
  description = "acesso do lab"

  ingress  {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = var.cidrs_acesso_ssh
    }

  tags = {
    Name = "ssh"
  }
}