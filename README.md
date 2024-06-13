# Assignment 3
Assignment 3 for scalable cloud applications course, currently Amazon AWS focused.
Html template was provided by https://github.com/larsappel

# Instructions
Start the script by entering the following command in the terminal:
You must have access to the email addresses for verification.

* ./main_run.sh "EMAILSENDFROM" "EMAILSENDTO" "STACKNAME" "SETBUCKETNAME" "REGION"

stackname, bucketname and region have default values. Emails are a must.
* Example: ./main_run.sh "sendFROM@email.com" "sendTO@email.com" "stackname" "bucketname" "eu-west-1"

# Requirements
* 2x Emails that you have access to. Preferbly without filters as it can block verifications. Recommend private emails instead of school/work ones.
* AWS CLI - be verified.
* Git bash terminal

# Tested on
* Windows 11
* Visual Studio Code, using Git Bash terminal window.

# What will main_run.sh do?
This script will ask you to verify two emails. If you've already done it you can skip it.
It will then create a AWS cloudformation stack that creates the following resources:
- DynamoDB table
- IAM roles for Lambda functions and CodePipeline
- S3 bucket
- Lambda functions
- CodeCommit repository
- CodePipeline

It will then wait for the stack to be created and create a new index file.
The new index file will be pushed to CodeCommit.
The script will then print the URL of the website.
Finally, it will ask you if you want to delete the stacks and the S3 bucket.

# End result?
Final result will be a static URL that you can go to, enter your details:
name, email and message.

The details will be saved in a DynamoDB table in AWS and your sendTO@email.com will receive a notification.

# Feedback
Is welcome and appreciated. Be nice!
