#! /bin/bash

aws_region=$1
image_id=$2
copy_image_id=$3
github_run_number=$4
copy_ami_name=$(aws ec2 describe-images --region eu-central-1 --image-ids $image_id | jq '.Images[].Tags[] | select(.Key == "Name") | .Value' | sed -e 's/^"//' -e 's/"$//')

sleep 330

ami_state=$(aws ec2 describe-images --region eu-central-1 --image-ids $copy_image_id | jq .Images[].State | sed -e 's/^"//' -e 's/"$//')
echo $ami_state
if [ $ami_state == "available" ]; then
    aws ec2 modify-image-attribute --region $aws_region --image-id $copy_image_id --launch-permission "Add=[{UserId=092228957173}]"
    aws ec2 create-tags --resources $copy_image_id --region $aws_region --tags Key=run_number,Value=$GITHUB_RUN_NUMBER
    aws ec2 create-tags --resources $copy_image_id --region $aws_region --tags Key=Name,Value="$copy_ami_name-release"
    aws ec2 create-tags --resources $image_id --region $aws_region --tags Key=run_number,Value=$GITHUB_RUN_NUMBER
    echo $ami_state
else
    echo $ami_state
    sleep 330
    aws ec2 modify-image-attribute --region $aws_region --image-id $copy_image_id --launch-permission "Add=[{UserId=092228957173}]"
    aws ec2 create-tags --resources $copy_image_id --region $aws_region --tags Key=run_number,Value=$GITHUB_RUN_NUMBER
    aws ec2 create-tags --resources $copy_image_id --region $aws_region --tags Key=Name,Value="$copy_ami_name-release"
    aws ec2 create-tags --resources $image_id --region $aws_region --tags Key=run_number,Value=$GITHUB_RUN_NUMBER
fi
