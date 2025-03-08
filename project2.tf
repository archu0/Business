
provider "aws" {
  region     = "ap-south-1"
}

resource "aws_security_group" "my_sg" {
  tags = {
    name = "my_sg"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}
resource "aws_instance" "server_one" {
  ami             = "ami-08fe5144e4659a3b3"
  instance_type   = "t2.micro"
  key_name        = "archana_09"
  security_groups = [aws_security_group.my_sg.name]
  count           = "2"
  tags = {
    Name = "server_one"
  }
  user_data = file("./sample2.sh")
}


output "private_ip" {
  value = aws_instance.server_one.*.private_ip
}


