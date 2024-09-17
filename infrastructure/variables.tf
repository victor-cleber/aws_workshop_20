variable "allowed-iplist" {
  description = "Remote IP can access the AWS infra"
  type        = set(string)
  default     = ["0.0.0.0/0"]
}

variable "vpc-name" {
  type    = string
  default = "vpc-glpi"
}


variable "region" {
  type        = string
  description = "AWS region where the infrastructure will be created."
  #default     = "ap-southeast-1"
  default = "us-east-1"
}

variable "workshop" {
  type        = string
  description = "Workshop Edition"
  default     = "Workshop-20"
}

variable "customer" {
  type        = string
  description = "Customer"
  default     = "Cloud Treinamentos - bootacamp"
}

variable "autor" {
  type        = string
  description = "Autor"
  default     = "Group 6"
}

variable "automation" {
  type        = string
  description = "Automation"
  default     = "terraform"
}