resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.terravpc.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "Main"
  }
}