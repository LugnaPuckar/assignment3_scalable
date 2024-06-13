#!/bin/bash

echo "Press Y to verify the emails, any other button to skip:"
read -n 1 input
echo

if [[ $input == [Yy] ]]; then
    emailOne="$1"
    emailTwo="$2"

    aws ses verify-email-identity --email-address $emailOne
    aws ses verify-email-identity --email-address $emailTwo

    echo "Sent email verifications to:"
    echo "---------------------"
    echo $emailOne
    echo $emailTwo
    echo "---------------------"

    echo "Please check your email to verify the email addresses."

    echo "When you have verified, press any key to continue..."
    read -n 1 -s

    echo "Status of email verification:"
    aws ses get-identity-verification-attributes --identities $emailOne $emailTwo
    echo "Press any key to continue..."
    read -n 1 -s

    echo "Continuing..."

else
    echo "Skipping..."
fi
