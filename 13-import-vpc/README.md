# terraform init
```
cd 13-import-vpc
terraform init
```

# Create a VPC with Name `Web VPC`

# Get the VPC ID of the VPC to import into Terraform
- Terraform requires the ID of the resource to be imported. 
```bash
VpcID=$(aws ec2 describe-vpcs --region us-west-2 --filters Name=tag:Name,Values='Web VPC' --output text --query "Vpcs[].VpcId") && echo $VpcID
```

#  Use terraform import specifying the aws_vpc.dev resource block and VPC ID:
```
terraform import aws_vpc.dev $VpcID
```

```
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

# An empty aws_vpc resource block is created as a place holder for the existing VPC in AWS
resource "aws_vpc" "dev" {}
```

# Copy the resource block output from the terraform show command:
```
terraform show
```

# overwrite the empty aws_vpc resource block by pasting over it with the new resource block content that was previously copied:
```
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

resource "aws_vpc" "dev" {
    arn                              = "arn:aws:ec2:us-west-2:466321120937:vpc/vpc-03ff644dd2fc6a1f1"
    assign_generated_ipv6_cidr_block = false
    cidr_block                       = "192.168.100.0/24"
    default_network_acl_id           = "acl-0aaee55c05eb36803"
    default_route_table_id           = "rtb-0b4e518ebd3cb0c43"
    default_security_group_id        = "sg-0fbb87979ea4a72f4"
    dhcp_options_id                  = "dopt-044cc06a5b17073cc"
    enable_classiclink               = false
    enable_classiclink_dns_support   = false
    enable_dns_hostnames             = true
    enable_dns_support               = true
    id                               = "vpc-03ff644dd2fc6a1f1"
    instance_tenancy                 = "default"
    main_route_table_id              = "rtb-0b4e518ebd3cb0c43"
    owner_id                         = "466321120937"
    tags                             = {
        "Name"                        = "Web VPC"
        "ca-creator"                  = "system"
        "ca-environment"              = "production"
        "ca-environment-session-id"   = "1282472"
        "ca-environment-session-uuid" = "5e814446-6e90-46f8-81bd-cd7562e2328f"
        "ca-persistent"               = "false"
        "ca-scope"                    = "lab"
    }
}
```

# terraform plan

# remove each argument that cannot be set
```
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

resource "aws_vpc" "dev" {
    assign_generated_ipv6_cidr_block = false
    cidr_block                       = "192.168.100.0/24"
    enable_classiclink               = false
    enable_classiclink_dns_support   = false
    enable_dns_hostnames             = true
    enable_dns_support               = true
    instance_tenancy                 = "default"
    tags                             = {
        "Name"                        = "Web VPC"
        "ca-creator"                  = "system"
        "ca-environment"              = "production"
        "ca-environment-session-id"   = "1282472"
        "ca-environment-session-uuid" = "5e814446-6e90-46f8-81bd-cd7562e2328f"
        "ca-persistent"               = "false"
        "ca-scope"                    = "lab"
    }
}
```

# terraform plan