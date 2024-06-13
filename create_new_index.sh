#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

STACKNAME="${1:-Assignment3Stack}"

# Get the API endpoint URL from the provided stack
APIENDPOINTURL=$(aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text)

# Creates new folder and then create a new index file with the API endpoint URL
mkdir -p ./codecommit
cp template_index.html ./codecommit/index.html

# Replace <API_ENDPOINT> placeholder with the actual API endpoint URL in the new index.html file
sed -i "s#<API_ENDPOINT>#$APIENDPOINTURL#g" ./codecommit/index.html
