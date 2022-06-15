terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.18"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_dynamodb_table_item" "example" {
  table_name = "example-name"
  hash_key   = "exampleHashKey"

  item = <<ITEM
{
  "exampleHashKey": {"S": "something"},
  "one": {"N": "11111"},
  "two": {"N": "22222"},
  "three": {"N": "33333"},
  "four": {"N": "44444"}
}
ITEM
}

resource "aws_dynamodb_table" "example" {
  name           = "example-name"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "exampleHashKey"

  attribute {
    name = "exampleHashKey"
    type = "S"
  }
}