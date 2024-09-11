variable "region" {
  type        = string
  description = "AWS region where the infrastructure will be created."
  default     = "us-east-1"
}

variable "workshop" {
  type        = string
  description = "Workshop Edition"
  default     = "workshop-20"
}

variable "customer" {
  type        = string
  description = "Autor de edição."
  default     = "Cloud Treinamentos"
}

variable "autor" {
  type        = string
  description = "Member of"
  default     = "Group 6"
}

variable "automation" {
  type        = string
  description = "Automation"
  default     = "terraform"
}