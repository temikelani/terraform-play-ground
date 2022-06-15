terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.7.0"
    }
  }
}

resource "aws_instance" "server" {
  ami = "ami-0d398eb3480cb04e7"
  instance_type = var.instance_type
  monitoring = false     

  root_block_device {
    delete_on_termination = false
    encrypted = true
    volume_size = var.instance_size
    volume_type = "standard"
  }

  tags = {
    Name = var.instance_name
  }

}