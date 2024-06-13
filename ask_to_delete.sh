#!/bin/bash

STACKNAME="${1:-Assignment3Stack}"
BUCKETNAME="${2:-very-cool-and-unique-contacts-assignment3}"
REGION="${3:-eu-west-1}"

echo "#######################################################"
echo "The script is now done."
echo "Do you wish to delete the created AWS resources?"
echo "Press Y to delete ALL, any other button to skip deletion:"
read -n 1 input
echo

if [[ $input == [Yy] ]]; then

# Force deletes the stacks
echo "Deleting stack $STACKNAME"
aws cloudformation delete-stack --stack-name $STACKNAME

# Change dir codecommit and removes old .git folder
cd ./codecommit/
rm -rf .git

# Emptying and delete the S3 bucket
aws s3 rm s3://$BUCKETNAME --recursive
aws s3api delete-bucket --bucket $BUCKETNAME --region eu-west-1

else
    echo "Skipping... Nothing was deleted."
fi