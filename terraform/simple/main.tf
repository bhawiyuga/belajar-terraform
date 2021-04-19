provider "aws" {
    region = "ap-southeast-1"
    shared_credentials_file = "~/.aws/credentials"
}

# Key pair
resource "aws_key_pair" "pubkey" {
  key_name   = "my-mac"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwtp2CL9AbTY2l0fv/9UjKt9eC945WKtiJJgx+EONxue/G3mM40n9ShqOLm/nBewvA1xh6RSgeiK47aiX0FwNkXy8Bvg/eRjDvBwkWq5CmlmR+wzS7hAVa1+1CXM7WmaNHCEcsyf8KmAso7hzCAVJxvMl15m7Z4zo+P1EAlTrSG+unX++IJEBp39PIt6uqx05r7hD7uIkj8W3XXCFjtHF9UbP4Ih3gldRO+Q0y789dv6FvF259P/zWr6vYmZRasLMLttDz89LvNceVGT3MD+oiipvfYoeo6Pq6/AqPcIpYccDCYZlG9kAY79gCkPU3cPiy3haTOw0RUfJNBL21drUx mac"
}

resource "aws_security_group" "sg_webserver" {
  name        = "sg_webserver"
  description = "Security group untuk webserver"

  ingress {
    description = "http traffic allowed"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh traffic allowed"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# Definisikan resource : EC2 instance
resource "aws_instance" "pub_instance" {
    count = 1
    ami = "ami-01581ffba3821cdf3" 
    instance_type = "t2.micro"
    key_name = "bhawiyuga-m1-mac"
    vpc_security_group_ids = [ 
        aws_security_group.sg_webserver.id 
    ]

    tags = {
        Name = "Public instance ${count.index + 1}"
    }
}