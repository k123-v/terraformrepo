variable "aws_region" {
  type = string
}
variable "secret_key" {
  type = string
}

variable "access_key" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "vpc_subnet" {
  type = string
}
variable "vpc_tags" {
  type = string
}
variable "subnet_tags" {
  type = string
}

variable "igw_tags" {
  type = string
}
variable "route_table_tags" {
  type = string
}
variable "securitygr" {
  type = string
}
variable "from_port" {
  type = number
}
variable "to_port" {
  type = number
}
variable "http_port" {
    type = number
}
variable "httpto_port" {
    type = number
}
variable "proto" {
  type = string
}
variable "privateip" {
  type = string
}

variable "countinst" {
  type = number
}
variable "amiID" {
  type = string
}
variable "instype" {
  type = string
}
variable "keydetail" {
  type = string
}
variable "availzone" {
  type = string
}
variable "ec2name" {
  type = string
}
variable "cidrgeneral" {
  type = string
}

variable "dnssupport" {
    type = bool 
}
variable "dnshostname" {
    type = bool 
}
variable "egressfport" {
    type = number 
}
variable "egresstport" {
    type = number 
}
variable "egressproto" {
    type = string 
}
