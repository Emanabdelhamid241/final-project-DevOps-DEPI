resource "aws_vpc" "terravpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "terra_vpc"
  }
  provisioner "local-exec" {   
    command ="echo ${self.id} > provisioner.txt"
    # when="destroy"
  }
}