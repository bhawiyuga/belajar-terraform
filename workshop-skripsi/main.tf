provider "aws" {
  region = "ap-southeast-1"
  shared_credentials_file = "~/.aws/credentials"
}

resource "aws_security_group" "webserver-sg" {
  name        = "allow_http_traffic"
  description = "Allow HTTP inbound traffic"

  ingress {
    description      = "TLS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web_traffic"
  }
}


resource "aws_instance" "moodle-server" {
    ami = "ami-0d058fe428540cd89"
    instance_type = "t2.micro"
    key_name = "bhawiyuga-m1-mac"

    vpc_security_group_ids = [
        aws_security_group.webserver-sg.id
    ]
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = aws_instance.moodle-server.public_ip
}