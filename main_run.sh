#!/bin/bash

#####################################################################################################
# Assignment 3 - Main script
# This script will ask you to verify two emails. If you've already done it you can skip it.
# It will then create a cloudformation stack that creates the following resources:
# - DynamoDB table
# - IAM roles for Lambda functions and CodePipeline
# - S3 bucket
# - Lambda functions
# - CodeCommit repository
# - CodePipeline
#
# It will then wait for the stack to be created and create a new index file.
# The new index file will be pushed to CodeCommit.
# The script will then print the URL of the website.
# Finally, it will ask you if you want to delete the stacks and the S3 bucket.
#####################################################################################################
# Instructions:
# Start the script by entering the following command in the terminal:
# You must have access to the email addresses for verification.
#
# ./main_run.sh "EMAILSENDFROM" "EMAILSENDTO" "STACKNAME" "SETBUCKETNAME" "REGION"
#
# Example: ./main_run.sh "sendFROM@email.com" "sendTO@email.com" "stackname" "bucketname" "eu-west-1"

# Exit immediately if a command exits with a non-zero status
set -e

# Bucketname MUST be unique and lowercase.
EMAILSENDFROM="$1"
EMAILSENDTO="$2"
STACKNAME="${3:-Assignment3Stack}"
SETBUCKETNAME="${4:-very-cool-and-unique-contacts-assignment3}"
REGION="${5:-eu-west-1}"

# Press Y if you want to verify the emails.
# Press N if you don't want to verify the emails.
./verify_emails.sh $EMAILSENDFROM $EMAILSENDTO

# Cloudformation.
aws cloudformation create-stack --stack-name $STACKNAME \
    --template-body file://CF_stack1.yaml \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters ParameterKey=FromEmail,ParameterValue=$EMAILSENDFROM \
    ParameterKey=ToEmail,ParameterValue=$EMAILSENDTO \
    ParameterKey=S3BucketName,ParameterValue=$SETBUCKETNAME \
    --region $REGION

# Wait for the stack creation to complete
echo "Waiting for the CloudFormation stack to be created..."
aws cloudformation wait stack-create-complete --stack-name $STACKNAME

# Create a new index file.
./create_new_index.sh $STACKNAME

# Push the new index file to CodeCommit.
./push_to_codecommit.sh

# Print the URL of the website.
WEBSITEURL=$(aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey=='WebsiteURL'].OutputValue" --output text)
echo ""
echo "-----------------------------------------------------"
echo "The contact form website is soon available at:" 
echo "$WEBSITEURL"
echo "-----------------------------------------------------"

# Ask to delete the stacks and the S3 bucket.
./ask_to_delete.sh $STACKNAME $SETBUCKETNAME $REGION