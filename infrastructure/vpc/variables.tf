variable "allowed-iplist" {
  description = "Remote IP can access the AWS infra"
  type        = set(string)
}

variable "vpc-name" {
  type = string
}