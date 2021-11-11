resource "null_resource" "install_docker" {
  provisioner "local-exec" {
    working_dir = "/tmp"
    command     = <<EOT
      if ! ``docker --version > /dev/null 2>&1`` ; then 
        sudo curl -sSL https://get.docker.com/ | sh;
        sudo usermod -aG docker `echo $USER`;
        sudo setfacl -m user:`echo $USER`:rw /var/run/docker.sock;
        sudo apt-get install -y python3 python3-pip;
        sudo apt install -y docker-compose
      fi
   EOT
  }
}

resource "null_resource" "install_services" {
  provisioner "local-exec" {
    working_dir = "/home/ubuntu"
    command     = <<EOT
        sudo apt install -y git;
        sleep 3;
        git clone https://github.com/levimurici/suricato-iot && cd suricato-iot;
        docker-compose up -d;
   EOT
  }
}