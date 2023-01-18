# resource "aws_instance" "first_instance" {
#   ami           = "ami-06878d265978313ca"
#   instance_type = "t2.micro"
#   tags = {
#     name = "web"
#   }
# }

# Deploy a mini-project
#Create a vpc
resource "aws_vpc" "mini_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "production"
  }
}
#create subnet
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.mini_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.gw]

  tags = {
    Name = "mini_pub1"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.mini_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "mini_priv1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.mini_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.gw]

  tags = {
    Name = "mini_pub2"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.mini_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "mini_priv2"
  }
}
#create a route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.mini_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id #putting this here for now, 
                                              #will update it later with nat gateway
  }

  tags = {
    Name = "mini_route"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mini_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}

#create route table association to seperate my public subnet from private subnet
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
  depends_on = [
    aws_subnet.private1,
    aws_route_table.private
  ]
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
  depends_on = [
    aws_subnet.private2,
    aws_route_table.private
  ]
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
  depends_on = [
    aws_subnet.public1,
    aws_route_table.public
  ]
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
  depends_on = [
    aws_subnet.public2,
    aws_route_table.public
  ]
}


#create internet gateway and update my rout table 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mini_vpc.id

  tags = {
    Name = "mini_gw"
  }
}

#create  a nat gateway with elastic ip address and update my route table
#Not creating nat gateway for now but will create it later when deploying instance
#to private subnet

#create security group
resource "aws_security_group" "allow_traffic" {
  name        = "allow_web_traffic"
  description = "Allow inbound traffic to communicate to internet"
  vpc_id      = aws_vpc.mini_vpc.id

  ingress {
    description = "Allow traffic from https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow traffic from http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ssh"
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
    Name = "Demo_SG"
  }
}
#create an instance
resource "aws_instance" "web-server" {
  ami                         = "ami-0b5eea76982371e91"
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  key_name                    = "server"
  subnet_id                   = aws_subnet.public1.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_traffic.id]
  user_data                   = <<-EOF
                  #!/bin/bash
                  yum update -y
                  yum amazon-linux-extras install php8.0 mariadb10.5
                  yum install -y httpd
                  yum systemctl start httpd

                  EOF

  tags = {
    Name = "web_server"
  }
}

output "name" {
  value       = aws_instance.web-server.associate_public_ip_address
  sensitive   = false
  description = "Print out my public IP Address"
  depends_on  = [aws_instance.web-server]
}

