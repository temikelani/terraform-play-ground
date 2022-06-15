terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.18"
    }
  }

  backend "s3" {
    # reset to     bucket = "RENAMEME!"
    bucket = "RENAMEME!"
    key    = "calabs/production/us-west-2/rslab/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}


provider "aws" {
  region = "us-west-2"
}


module "webserver" {
  source = "./modules/ec2"
  instance_type = "t2.micro"
  instance_size = 20

  instance_name = "cloudacademylabs"
}

output "server_id" {
  description = "id of EC2"
  value = module.webserver.id
}