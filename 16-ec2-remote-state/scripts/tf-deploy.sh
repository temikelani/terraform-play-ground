#!/bin/bash -ex

# apply, plan or destroy
COMMAND=$1 


case $COMMAND in

  plan)
    terraform init
    terraform plan
    ;;

  apply)
    terraform init
    terraform apply -auto-approve
    ;;

  destroy)
    #empty s3 bucket
    aws s3 rm s3://$S3NAME --recursive
    aws s3api delete-bucket --bucket $S3NAME --region us-west-2
    aws dynamodb delete-table --table-name $TABLE_NAME

    terraform init
    terraform destroy -auto-approve
    
  # sed -i 's/RENAMEME!/'"${S3NAME}"'/g' main.tf
    sed -i 's/'"${S3NAME}"'/RENAMEME!/g' main.tf
    ;;

  *)
    echo -n "Wrong arguments : Run script as follows:" 
    echo -n "Wrong arguments : ./run.sh arg1:" 
    echo -n "Where arg1: plan | apply | destroy"
    ;;
esac

