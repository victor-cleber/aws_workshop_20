module "vpc" {
  source = "./vpc"

  allowed-iplist = ["0.0.0.0/0"]

  vpc-name = "vpc-glpi"  
}

