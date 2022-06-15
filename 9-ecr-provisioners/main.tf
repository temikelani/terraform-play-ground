terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.7"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# You can add provisioner blocks inside of resources. However, it's best practice to create a null resource block when possible. 
# This provisioner block also has the when = destroy attribute, which tells Terraform only to run this only when the resource is being destroyed. 

# Running terraform destroy will execute the commands inside the provisioner block, pull the latest image from the repository, and save it as a tar file before deleting the ECR resource.

resource "aws_ecr_repository" "ecr" {
  name = "catest"

  provisioner "local-exec" {
    when = destroy

    command = <<EOF
    $(aws ecr get-login --region us-west-2 --no-include-email)
    docker pull ${self.repository_url}:latest
    docker save --output catest.tar ${self.repository_url}:latest 
    EOF
  }

}

# This is an empty resource that will run a series of commands on the local endpoint running Terraform. When the code is executed in this main.tf file, it will create an ECR resource and then perform the commands stated in the provisioner block to automatically upload a Docker image to the container registry. 

# Needs Docker client and AWS CLI
#Import Container Image to Elastic Container Registry
resource "null_resource" "image" {

  provisioner "local-exec" {
    command = <<EOF
      $(aws ecr get-login --region us-west-2 --no-include-email)
      docker pull hello-world:latest
      docker tag hello-world:latest ${aws_ecr_repository.ecr.repository_url}
      docker push ${aws_ecr_repository.ecr.repository_url}:latest
    EOF
  }
}