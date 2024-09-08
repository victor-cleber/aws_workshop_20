# VPC 
output "vpc-name" {
  description = "Nome da VPC"
  value       = aws_vpc.vpc.tags["Name"]
}

output "vpc-id" {
  description = "Nome da VPC"
  value       = aws_vpc.vpc.id
}

output "vpc-subnet-public-1a-id" {
  description = "VPC: Public Subnet 1a:ID"
  value       = aws_subnet.vpc-subnet-public-1a.id
}

output "vpc-subnet-public-1b-id" {
  description = "VPC: Public Subnet 1b:ID"
  value       = aws_subnet.vpc-subnet-public-1b.id
}

output "vpc-subnet-private-1a-id" {
  description = "VPC: Private Subnet 1a:ID"
  value       = aws_subnet.vpc-subnet-private-1a.id
}

output "vpc-subnet-private-1b-id" {
  description = "VPC: Private Subnet 1b:ID"
  value       = aws_subnet.vpc-subnet-private-1b.id
}

output "vpc-sg-allow-all-id" {
  description = "VPC: Security group Allow All:ID"
  value       = aws_security_group.vpc-sg-allow-all.id
}

output "vpc-sg-allow-all-name" {
  description = "VPC: Security group Allow All:Name"
  value       = aws_security_group.vpc-sg-allow-all.name
}

output "vpc-sg-instances-id" {
  description = "VPC: Security group for EC2:ID"
  value       = aws_security_group.vpc-sg-instances.id
}

output "vpc-sg-instances-name" {
  description = "VPC: Security group For EC2:Name"
  value       = aws_security_group.vpc-sg-instances.name
}

output "vpc-sg-rds-id" {
  description = "VPC: Security group for RDS:ID"
  value       = aws_security_group.vpc-sg-rds.id
}

output "vpc-sg-rds-name" {
  description = "VPC: Security group for RDS:Name"
  value       = aws_security_group.vpc-sg-rds.name
}

output "vpc-sg-efs-mountpoints-id" {
  description = "VPC: Security group for EFS mount points:ID"
  value       = aws_security_group.vpc-sg-efs-mountpoints.id
}

output "vpc-sg-efs-mountpoints-name" {
  description = "VPC: Security group for EFS mount points:Name"
  value       = aws_security_group.vpc-sg-efs-mountpoints.name
}

output "vpc-sg-alb-glpi-id" {
  description = "VPC: Security group for ALB GLPI:ID"
  value       = aws_security_group.vpc-sg-alb-odoo.id
}

output "vpc-sg-alb-glpi-name" {
  description = "VPC: Security group for ALB GLPI:Name"
  value       = aws_security_group.vpc-sg-alb-odoo.name
}