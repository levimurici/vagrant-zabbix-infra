resource "null_resource" "install_docker" {
  provisioner "local-exec" {
    working_dir = "/tmp"
    command     = <<EOT
      if ! ``docker --version > /dev/null 2>&1`` ; then 
        sudo curl -sSL https://get.docker.com/ | sh;
        sudo usermod -aG docker `echo $USER`;
        sudo setfacl -m user:`echo $USER`:rw /var/run/docker.sock
      fi
   EOT
  }
}