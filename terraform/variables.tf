variable "instance_type" {
  type = string
  default = "t2.medium"  
}
variable "instance_ami" {
  type = string
}
variable "key_pair" {
  type = string
  default = "TMS-Project"
}
variable "master-count" {
type = string
description = "Number of VM"
default     =  1
}
variable "etcd-count" {
type = string
description = "Number of VM"
default     =  1
}
variable "worker-count" {
type = string
description = "Number of VM"
default     =  1
}
variable "inventory_file" {
default = "inventory.ini"
}
variable "master-name" {
type = string
}
variable "etcd-name" {
type = string
}
variable "worker-name" {
type = string
}
