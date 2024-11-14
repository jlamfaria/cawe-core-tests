#! /bin/bash

region=$1
AMI_name=$2
images=$(aws ec2 describe-images --region $region --owners self --query "Images[*].ImageId" --output json)
echo "Total number of existing images: "
echo $images | jq '. | length'
echo $images | jq -c '.[]' | while read object; do
    ami_id=$(sed -e 's/^"//' -e 's/"$//' <<<"$object") 
    if [ $ami_id != $AMI_name ]; then 
    echo "---"
    echo $ami_id
    snapshot_id=$(aws ec2 describe-images --region $region --image-ids $ami_id --query "Images[].BlockDeviceMappings[].Ebs.SnapshotId" --output text 2> /dev/null)
    echo "Snapshot ID: $snapshot_id"
    aws ec2 deregister-image --image-id $AMI_name
    ret=$?
    if [ $ret -eq 0 ]; then
        volume_id=$(aws ec2 describe-snapshots --region $region --snapshot-ids $snapshot_id --query "Snapshots[].VolumeId" --output text)
        echo "Volume: $volume_id"
        aws ec2 delete-snapshot --snapshot-id $snapshot_id
    fi
    fi
done