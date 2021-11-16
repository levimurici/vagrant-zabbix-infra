#Variáveis keyname
variable "key_name" {
    /* type = "map" */
    default = {
        "keyname-services" = "terraform-aws-dnd-devops-labs"
    }
}

#Variáveis das imagens
variable "amis" {
    /* type = "map" */
    default = {
        "ami-services" = "ami-083654bd07b5da81d"
    }
}

#Variáveis das imagens
variable "cdirs_acesso_ssh" {
    /* type = "list" */
    /* "dnd-devops-lab" = "177.50.229.182/32" */
    default = {
        "dnd-lab" = "177.50.229.182/32",
        "rede-privada" = "10.0.0.0/16"
    }
}