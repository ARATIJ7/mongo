provider "aws" {
  region = "us-west-2"
  access_key = var.aws_access_key_id_west
  secret_key = var.aws_secret_access_key_west
}

# VPC for West Region
resource "aws_vpc" "west_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "West-VPC"
  }
}

resource "aws_subnet" "west_subnet" {
  vpc_id = aws_vpc.west_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "West-Subnet"
  }
}

resource "aws_internet_gateway" "west_igw" {
  vpc_id = aws_vpc.west_vpc.id
  tags = {
    Name = "West-Internet-Gateway"
  }
}

resource "aws_route_table" "west_route_table" {
  vpc_id = aws_vpc.west_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.west_igw.id
  }
  tags = {
    Name = "West-Route-Table"
  }
}

resource "aws_route_table_association" "west_rta" {
  subnet_id = aws_subnet.west_subnet.id
  route_table_id = aws_route_table.west_route_table.id
}

resource "aws_security_group" "west_mongodb_sg" {
  vpc_id = aws_vpc.west_vpc.id
  name = "west-mongodb-sg"
  description = "Security group for MongoDB in West region"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
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
    Name = "West-MongoDB-SG"
  }
}

resource "aws_key_pair" "west_key_pair" {
  key_name   = "west-key-pair"
  public_key = var.ssh_public_key
}

resource "aws_instance" "west_mongodb_instance_1" {
  ami                         = var.ami_id_west
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.west_key_pair.key_name
  subnet_id                   = aws_subnet.west_subnet.id
  vpc_security_group_ids      = [aws_security_group.west_mongodb_sg.id]
  associate_public_ip_address = true

  user_data = file("userdata-primary.sh")

  tags = {
    Name = "West-MongoDB-Instance-1"
  }
}

resource "aws_instance" "west_mongodb_instance_2" {
  ami                         = var.ami_id_west
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.west_key_pair.key_name
  subnet_id                   = aws_subnet.west_subnet.id
  vpc_security_group_ids      = [aws_security_group.west_mongodb_sg.id]
  associate_public_ip_address = true

  user_data = file("userdata-replica.sh")

  tags = {
    Name = "West-MongoDB-Instance-2"
  }
}

resource "aws_instance" "west_mongodb_instance_3" {
  ami                         = var.ami_id_west
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.west_key_pair.key_name
  subnet_id                   = aws_subnet.west_subnet.id
  vpc_security_group_ids      = [aws_security_group.west_mongodb_sg.id]
  associate_public_ip_address = true

  user_data = file("userdata-replica.sh")

  tags = {
    Name = "West-MongoDB-Instance-3"
  }
}

output "west_instance_1_public_ip" {
  value = aws_instance.west_mongodb_instance_1.public_ip
}

output "west_instance_2_public_ip" {
  value = aws_instance.west_mongodb_instance_2.public_ip
}

output "west_instance_3_public_ip" {
  value = aws_instance.west_mongodb_instance_3.public_ip
}
