variable "region" {
  type = string
}

variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

#  pass with export? keep ip off github
# TF_VAR_workstation_ip=ip/32

variable "workstation_ip" {
  type = string
}

# ubuntu servers
variable "amis" {
  type = map(any)
  default = {
    "us-east-1" : "ami-09d56f8956ab235b3"
    "us-east-2" : "ami-0aeb7c931a5a61206"
  }
}