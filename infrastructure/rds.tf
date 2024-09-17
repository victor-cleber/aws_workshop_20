resource "aws_db_subnet_group" "glpi_db_subnet_group" {
  name = "glpi-db-subnet-group"
  #subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  subnet_ids = [aws_subnet.vpc-db-subnet-1a.id, aws_subnet.vpc-db-subnet-1b.id]

  tags = {
    Name = "GLPI DB Subnet Group"
  }
}

#To associate this subnet group with our database instance we 
#created in the previous section, we update the configuration as shown below.
resource "aws_db_instance" "default" {
  identifier = "glpidb"
  instance_class = "db.t2.micro"
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  storage_type = "gp2"  
  username = "dbuser"
  password = "dbpassword" #var.db_passwd
  db_subnet_group_name = aws_db_subnet_group.glpi_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.vpc-sg-rds.id]
  


  skip_final_snapshot = true
}