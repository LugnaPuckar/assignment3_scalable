#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Change dir codecommit
cd ./codecommit/

# Removes old .git folder and initializes a new one
rm -rf .git
git init
git add .
git commit -m 'Adding version one of index.html'

# Create a new CodeCommit repository with a name and description
REPO_NAME="${1:-ContactForm}"
AWS_REGION="${2:-eu-west-1}"

# Get the repository clone URL
echo "Fetching the clone URL for the CodeCommit repository"
GET_REPO_OUTPUT=$(aws codecommit get-repository --repository-name $REPO_NAME --region $AWS_REGION)

# Extract the clone URL using grep and sed
CLONE_URL=$(echo "$GET_REPO_OUTPUT" | grep -o '"cloneUrlHttp":[^,]*' | sed 's/"cloneUrlHttp": "\(.*\)"/\1/')

# Set CodeCommit repo as origin
git remote add origin $CLONE_URL

# Push to CodeCommit
git push -u origin main

# Print success message
echo "Repository pushed to CodeCommit successfully!"

# Press a key to continue..
read -n 1 -s -r -p "Press any key to continue"
