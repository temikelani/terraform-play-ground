#!/bin/bash -ex

# create s3 Bucket for backend
export S3NAME="terraformstate$(date | md5sum | head -c 8)" 

aws s3api create-bucket \
    --bucket $S3NAME \
    --region us-west-2 \
    --create-bucket-configuration \
    LocationConstraint=us-west-2

# enable encryption on the S3 bucket:
aws s3api put-bucket-encryption \
    --bucket $S3NAME \
    --server-side-encryption-configuration={\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}

# Enable versioning on the bucket:
aws s3api put-bucket-versioning --bucket $S3NAME --versioning-configuration Status=Enabled

#create dynamodbtable
aws dynamodb create-table \
    --table-name terraform-state-lock \
    --attribute-definitions \
        AttributeName=LockID,AttributeType=S \
    --key-schema \
        AttributeName=LockID,KeyType=HASH \
    --region us-west-2 \
    --provisioned-throughput \
        ReadCapacityUnits=20,WriteCapacityUnits=20

export TABLE_NAME=$(aws dynamodb list-tables --region us-west-2 --query "TableNames[]" --output text)


# change out the S3 bucket name with the one we created
sed -i 's/RENAMEME!/'"${S3NAME}"'/g' main.tf

echo "Use Bucket: $S3NAME and Table: $TABLE"
echo "S3_bucket_name: $S3NAME"