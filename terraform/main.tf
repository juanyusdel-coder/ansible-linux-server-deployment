resource "aws_security_group" "web_sg" {
  name        = "linux-server-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change to your IP for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "linux_server" {
  ami           = "ami-0ebfd15d091950288" # Amazon Linux 2023 (check your region)
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # This runs automatically when the server starts
  user_data = file("${path.module}/../terraform/scripts/setup.sh")

  tags = {
    Name = "AutoDeployed-Linux-Server"
  }
}