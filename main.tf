# Definisikan provider aws
provider "aws"{
   region = "ap-southeast-1"
   shared_credentials_file = "~/.aws/credentials"
}

# Konfigurasi security group
resource "aws_security_group" "sg_webserver" {
  name        = "sg_webserver"
  description = "Security group untuk webserver"
  vpc_id = aws_vpc.main.id

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
# Konfigurasi vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Konfigurasi subnet
resource "aws_subnet" "public_sub" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private_sub" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet"
  }
}

# Konfigurasi routing, igw, dan nat (eksplorasi mandiri)
# - Konfigurasi route table (https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)
# - Konfigurasi internet gateway untuk subnet public (https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)
# - Konfigurasi NAT gateway/NAT instance untuk subnet private (https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway)
# - Konfigurasi route association ke subnet

# Definisikan resource : EC2 instance
resource "aws_instance" "pub_instance" { 
    ami = "ami-01581ffba3821cdf3" 
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_sub.id
    vpc_security_group_ids = [ 
        aws_security_group.sg_webserver.id 
    ]

    tags = {
        Name = "Public instance"
    }
}

resource "aws_instance" "priv_instance" { 
    ami = "ami-01581ffba3821cdf3" 
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private_sub.id
    vpc_security_group_ids = [ 
        aws_security_group.sg_webserver.id 
    ]

    tags = {
        Name = "Private instance"
    }
}



