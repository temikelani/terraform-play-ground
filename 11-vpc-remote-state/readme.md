# Introduction

Terraform state is stored locally by default in a terraform.tfstate file. With remote state, Terraform writes to a state file hosted in a remote data store. This provides a few advantages over a local state file like security, version control, and centralized storage. It also provides state locking, which is where only one person can modify the state file at a time, which prevents teammates from writing over each other. In AWS you can use an S3 bucket for storing the state file and a DynamoDB table for state locking.

- Create a DynamoDB table and S3 bucket and configure Terraform to use remote state.

# Create s3 bucket

```
S3NAME="terraformstate$(date | md5sum | head -c 8)" 

aws s3api create-bucket \
    --bucket $S3NAME \
    --region us-west-2 \
    --create-bucket-configuration \
    LocationConstraint=us-west-2
```

# enable encryption on the S3 bucket:

```
aws s3api put-bucket-encryption \
    --bucket $S3NAME \
    --server-side-encryption-configuration={\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}

```

#  Enable versioning on the bucket:

- Versioning allows multiple versions of the state file to be saved which provides roll back safety for the state.

```
aws s3api put-bucket-versioning --bucket $S3NAME --versioning-configuration Status=Enabled
```

# Create a DynamoDB Table

```
aws dynamodb create-table \
    --table-name terraform-state-lock \
    --attribute-definitions \
        AttributeName=LockID,AttributeType=S \
    --key-schema \
        AttributeName=LockID,KeyType=HASH \
    --region us-west-2 \
    --provisioned-throughput \
        ReadCapacityUnits=20,WriteCapacityUnits=20
```

- Storing the state remotely is great for centralized storage. However, there is risk of multiple teammates working from the same state file at the same time. If you understand how state works, you know that this would cause major issues when managing Terraform resource with state. State locking is a feature that prevents that state from being opened when it is already in use. The DynamoDB table is used by Terraform to set and unset the state locks. The AWS infrastructure is in place to use remote state in a Terraform configuration


#  Use the sed command to change out the S3 bucket name with the one we created:
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.7"
    }
  }
  backend "s3" {
    bucket = "RENAMEME!"
    key    = "calabs/production/us-west-2/rslab/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```
```
cd terraformlab
sed -i 's/RENAMEME!/'"${S3NAME}"'/g' main.tf
```

# terraform plan , apply

# View the state file within the S3 bucket:

```
aws s3 ls s3://$S3NAME/calabs/production/us-west-2/rslab/
```