data "aws_ami_ids" "amzn-linux-2023-ami" {
  #most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}


data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}



resource "aws_instance" "glpi_srv" {
  #count = 1
  #ami   = var.amis["Ubunt-us-east-1"]
  #ami   = data.aws_ami.amazon_linux.id
  #ami = "ami-04a5ce820a419d6da"
  ami           = "ami-0182f373e66f89c85"
  instance_type = "t2.micro"

  #key_name = var.key_name

  #Selecionar VPC
  #vpc_id      = module.vpc.vpc_id

  #Selecionar SubRede
  #subnet_id = module.vpc.vpc_id.public_subnets[0]
  subnet_id = aws_subnet.vpc-subnet-public-1a.id

  #Atribuir IP Publico
  associate_public_ip_address = true
  #iam_instance_profile        = aws_iam_instance_profile.ecs_node.id
  #Definir Volume

  user_data = file("bootstrap.sh")

  #user_data = << EOF
  #              #! /bin/bash
  #              cd /home/ubuntu
  #              apt update -y
  #              apt upgrade -y
  #              apt install wget unzip -y
  #              TER_VER=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1')
  #              wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
  #              unzip terraform_${TER_VER}_linux_amd64.zip
  #              mv terraform /usr/local/bin/
  #              EOF

  # Associar o Role SSM à instância EC2
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  tags = {
    #Name        = "gpli-${count.index}"
    Name = "gpli_srv"
  }
  #vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}",
  #"${aws_security_group.acesso-http.id}", "${aws_security_group.acesso-rds.id}"]

  #vpc_security_group_ids = ["${aws_security_group.acesso-http.id}", "${aws_security_group.vpc-sg-rds.id}"]
  vpc_security_group_ids = ["${aws_security_group.vpc-sg-allow-all.id}"]


}

/*
resource "aws_security_group" "acesso-ssh" {
  vpc_id = module.vpc.public_subnets.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite acesso SSH de qualquer lugar
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
*/
#vpc_security_group_ids = [aws_security_group.acesso-rds.id]
#resource "aws_instance" "app_server4" {
#  #count = 3
#  ami           = var.amis["Ubnt-us-east-1"]
#  instance_type = "t2.micro"
#  key_name = var.key_name

#  tags = {
#    Name = "Terraform-Dev-4"       ###${count.index}"
#  }
#  vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"]
#  depends_on = [ aws_s3_bucket.Dev4 ]
#}

#resource "aws_instance" "app_server7" {
#  #provider = aws.us-east-2
#  #count = 3
#  ami           = var.amis["Ubnt-us-east-2"]
#  instance_type = "t2.micro"
#  key_name = var.key_name

#  tags = {
#    Name = "Terraform-Dev-7"       ###${count.index}"
#  }
#  vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"]
#  #depends_on = [ aws_dynamodb_table.basic-dynamodb-table ]
#}



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

resource "aws_security_group" "vpc-sg-alb-glpi" {
  name        = "vpc_sg_alb-glpi"
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
    Name = "${var.vpc-name}-sg-alb-glpi"
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