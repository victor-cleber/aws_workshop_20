# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc-name
  }
}

# Network ACL
resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  tags = {
    Name = "nacl-${var.vpc-name}-default"
  }
}

resource "aws_network_acl" "vpc-nacl-private-subnets" {
  vpc_id = aws_vpc.vpc.id

  ingress {    
    rule_no    = 100
    protocol   = "tcp"
    from_port  = 8069
    to_port    = 8069
    action     = "allow"
    cidr_block = "0.0.0.0/0"
  }

  ingress {    
    rule_no    = 200
    protocol   = "tcp"
    from_port  = 5432
    to_port    = 5432
    action     = "allow"
    cidr_block = "0.0.0.0/0"    
  }

  ingress {    
    rule_no    = 300
    protocol   = "tcp"
    from_port  = 2049
    to_port    = 2049
    action     = "allow"
    cidr_block = "0.0.0.0/0"    
  }

  ingress {    
    rule_no    = 10000
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    action     = "allow"
    cidr_block = "0.0.0.0/0"    
  }

  egress {
    rule_no    = 10000
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    action     = "allow"
    cidr_block = "0.0.0.0/0"    
  }

  tags = {
    Name = "nacl-${var.vpc-name}-private-subnets"
  }
}

resource "aws_network_acl" "vpc-nacl-public-subnets" {
  vpc_id = aws_vpc.vpc.id

  ingress {    
    rule_no    = 100
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
    action     = "allow"
    cidr_block = "0.0.0.0/0"    
  }

  ingress {    
    rule_no    = 200
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    action     = "allow"
    cidr_block = "0.0.0.0/0"    
  }

  ingress {    
    rule_no    = 300
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    action     = "allow"
    cidr_block = "0.0.0.0/0"    
  }

  ingress {    
    rule_no    = 10000
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    action     = "allow"
    cidr_block = "0.0.0.0/0"    
  }

  egress {
    rule_no    = 100
    protocol   = "tcp"
    from_port  = 8069
    to_port    = 8069
    action     = "allow"
    cidr_block = "0.0.0.0/0"    
  }

  # egress {
  #   rule_no    = 200
  #   protocol   = "tcp"
  #   from_port  = 443
  #   to_port    = 443
  #   action     = "allow"
  #   cidr_block = "0.0.0.0/0"    
  # }

  egress {
    rule_no    = 10000
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    action     = "allow"
    cidr_block = "0.0.0.0/0"    
  }

  tags = {
    Name = "nacl-${var.vpc-name}-public-subnets"
  }
}

# Network ACL associations
resource "aws_network_acl_association" "nacl-association-subnet-private-1a" {
  network_acl_id = aws_network_acl.vpc-nacl-private-subnets.id
  subnet_id      = aws_subnet.vpc-subnet-private-1a.id
}
resource "aws_network_acl_association" "nacl-association-subnet-private-1b" {
  network_acl_id = aws_network_acl.vpc-nacl-private-subnets.id
  subnet_id      = aws_subnet.vpc-subnet-private-1b.id
}

resource "aws_network_acl_association" "nacl-association-subnet-public-1a" {
  network_acl_id = aws_network_acl.vpc-nacl-public-subnets.id
  subnet_id      = aws_subnet.vpc-subnet-public-1a.id
}
resource "aws_network_acl_association" "nacl-association-subnet-public-1b" {
  network_acl_id = aws_network_acl.vpc-nacl-public-subnets.id
  subnet_id      = aws_subnet.vpc-subnet-public-1b.id
}


# Public Subnet 1a
resource "aws_subnet" "vpc-subnet-public-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.20.101.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.vpc-name}-subnet-public-1a"
  }
}

# Public Subnet 1b
resource "aws_subnet" "vpc-subnet-public-1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.20.102.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.vpc-name}-subnet-public-1b"
  }
}

# Private Subnet 1a
resource "aws_subnet" "vpc-subnet-private-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.20.201.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.vpc-name}-subnet-private-1a"
  }
}

# Private Subnet 1b
resource "aws_subnet" "vpc-subnet-private-1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.20.202.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.vpc-name}-subnet-private-1b"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-${var.vpc-name}"
  }
}

# Router tables
resource "aws_default_route_table" "rt-vpc-default" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = {
    Name = "rt-${var.vpc-name}-default"
  }
}

resource "aws_route_table" "rt-vpc-public-subnet" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-igw.id
  }

  tags = {
    Name = "rt-${var.vpc-name}-public-subnet"
  }
}

resource "aws_route_table" "rt-vpc-private-subnet" {
  vpc_id = aws_vpc.vpc.id  

  tags = {
    Name = "rt-${var.vpc-name}-private-subnet"
  }
}

# Router tables public subnets association
resource "aws_route_table_association" "rta-vpc-public-subnet-1a" {
  subnet_id      = aws_subnet.vpc-subnet-public-1a.id
  route_table_id = aws_route_table.rt-vpc-public-subnet.id
}
resource "aws_route_table_association" "rta-vpc-public-subnet-1b" {
  subnet_id      = aws_subnet.vpc-subnet-public-1b.id
  route_table_id = aws_route_table.rt-vpc-public-subnet.id
}

# Router tables private subnets association
resource "aws_route_table_association" "rta-vpc-private-subnet-1a" {
  subnet_id      = aws_subnet.vpc-subnet-private-1a.id
  route_table_id = aws_route_table.rt-vpc-private-subnet.id
}
resource "aws_route_table_association" "rta-vpc-private-subnet-1b" {
  subnet_id      = aws_subnet.vpc-subnet-private-1b.id
  route_table_id = aws_route_table.rt-vpc-private-subnet.id
}

# Security groups
resource "aws_security_group" "vpc-sg-allow-all" {
  name        = "vpc_sg_allow_all"
  description = "Security group para permitir tudo"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow all"
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

  tags = {
    Name = "${var.vpc-name}-sg-allow-all"
  }
}

resource "aws_security_group" "vpc-sg-instances" {
  name        = "vpc_sg_instances"
  description = "Security group for instances EC2"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow GLPI access"
    from_port   = 8069
    to_port     = 8069
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc-name}-sg-instances"
  }
}

resource "aws_security_group" "vpc-sg-rds" {
  name        = "vpc_sg_rds"
  description = "Security group for RDS Maria DB"
  vpc_id      = aws_vpc.vpc.id  

  ingress {
    description = "Allow Maria DB access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc-name}-sg-rds"
  }
}

resource "aws_security_group" "vpc-sg-efs-mountpoints" {
  name        = "vpc_sg_efs_mountpoints"
  description = "Security group for EFS mount points"
  vpc_id      = aws_vpc.vpc.id

    ingress {
    description = "Allow EFS access"
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc-name}-sg-efs-mountpoints"
  }
}

resource "aws_security_group" "vpc-sg-alb-odoo" {
  name        = "vpc_sg_alb-odoo"
  description = "Security group for ALB GLPI"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc-name}-sg-alb-odoo"
  }
}

resource "aws_security_group" "vpc-sg-allow-ssh-by-ip" {
  name        = "vpc_sg_allow_ssh_by_ip"
  description = "Security group to allow connection ssh from a specifc IP address"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow SSH connection from a specifc IP address"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed-iplist
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc-name}-sg-allow-ssh-by-ip"
  }
}