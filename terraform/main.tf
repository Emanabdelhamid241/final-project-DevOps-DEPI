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
              # Update package manager and install Java (required for Jenkins)
              sudo yum update -y
              sudo amazon-linux-extras install java-openjdk11 -y

              # Add Jenkins repo and import the GPG key
              wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

              # Install Jenkins
              sudo yum install jenkins -y

              # Start Jenkins
              sudo systemctl start jenkins
              sudo systemctl enable jenkins

              # Enable firewall (optional) and allow Jenkins to communicate on port 8080
              sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
              sudo firewall-cmd --reload

              # Jenkins will run on port 8080
/*#                     #!/bin/bash
#                     sudo apt-get update
#                     sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
#                     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#                     sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#                     sudo apt-get update
#                     sudo apt-get install -y docker-ce

#                     # Install Git 
#                     sudo apt-get install -y git

#                     sudo systemctl start docker
#                     sudo systemctl enable docker
#                     sudo groupadd docker
#                     sudo usermod -aG docker $USER && newgrp docker
#                     sudo chmod 666 /var/run/docker.sock
                    
#                     # Install Docker compose
#                     sudo apt-get install -y docker-compose
#                     # Install Jenkins (latest stable version)
# echo "--------------------Installing Jenkins--------------------"
# sudo apt -y install wget git
# wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /etc/apt/trusted.gpg.d/jenkins.asc
# echo "deb https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
# sudo apt-get update -y
# sudo apt-get install jenkins -y
# sudo systemctl enable jenkins
# sudo systemctl start jenkins
*/

  EOF
 tags = {
    Name = "JenkinsServerInstance"
  }
  depends_on = [aws_key_pair.UbuntuKP]

}

