#!/bin/bash

# Update package manager and install Java (required for Jenkins)
sudo yum update -y
sudo amazon-linux-extras install java-openjdk11 -y

# Add Jenkins repo and import the GPG key
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

# Install Jenkins
sudo yum install jenkins -y

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Allow Jenkins traffic on port 8080 via firewalld (if firewalld is enabled)
if sudo systemctl is-active --quiet firewalld; then
  sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
  sudo firewall-cmd --reload
fi

# Display Jenkins status
sudo systemctl status jenkins

# Output Jenkins initial admin password
echo "Jenkins installation is complete. You can access it at http://<your-ec2-public-ip>:8080"
echo "Use the following command to get the initial admin password:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
