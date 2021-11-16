resource "aws_security_group" "acesso-dnd" {
  name        = "acesso-dnd"
  description = "acesso do lab"

  ingress  {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = "${var.cdirs_acesso_ssh}" //[var.cdirs_acesso_ssh["dnd-lab"], var.cdirs_acesso_ssh["rede-privada"]] /* aws_vpc.dnd_vpc.cidr_block */
    }

  egress  {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "ssh"
  }
}