module "my_network" {
  source      = "./network"
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
  ami = var.ami
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}
resource "aws_key_pair" "UbuntuKP" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "JenkinsServer" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name = aws_key_pair.UbuntuKP.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]
##
  associate_public_ip_address= true
  

  user_data = <<-EOF
    #!/bin/bash
    # Update package lists
    sudo apt update -y

    # Install Java (required by Jenkins)
    sudo apt install openjdk-11-jdk -y

    # Add Jenkins repository key and source list
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
      /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | \
      sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

    # Update package lists again
    sudo apt update -y

    # Install Jenkins
    sudo apt install jenkins -y

    # Start and enable Jenkins service
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
  EOF

 tags = {
    Name = "JenkinsServerInstance"
  }

  depends_on = [aws_key_pair.UbuntuKP]

}

