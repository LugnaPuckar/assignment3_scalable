#!/bin/bash

echo "Press Y to verify the emails, any other button to skip:"
read -n 1 input
echo

if [[ $input == [Yy] ]]; then
    emailOne="$1"
    emailTwo="$2"

    # Verify email addresses
    send_verify_emails() {
        aws ses verify-email-identity --email-address $1
    }

    # Check verification status
    check_verify_status() {
        aws ses get-identity-verification-attributes --identities $1 $2
    }

    # Display information about sent verifications
    information_verify_emails() {
        echo "Sent email verifications to:"
        echo "---------------------------------"
        echo $1
        echo $2
        echo "---------------------------------"
        echo "Please check your two emails to verify the email addresses with Amazon AWS."
        echo "When you have verified, press any key to continue..."
        read -n 1 -s
    }

    echo_verify_status() {
        echo "Status of email verification:"
        echo "$(check_verify_status $1 $2)"
    }

    verify_main_loop(){
        send_verify_emails $1
        send_verify_emails $2
        information_verify_emails $1 $2
        echo_verify_status $1 $2
    }

    # Initial verify run
    verify_main_loop $emailOne $emailTwo

    # Loop to re-verify until both are verified
    while true; do
        # Check verification status for each email individually
        statusOne=$(check_verify_status $emailOne | grep '"VerificationStatus": "Success"')
        statusTwo=$(check_verify_status $emailTwo | grep '"VerificationStatus": "Success"')

        # Check if both emails are successfully verified
        if [[ -n "$statusOne" && -n "$statusTwo" ]]; then
            echo "Email addresses successfully verified."
            break
        else
            echo "Email verification is not successful."
            verify_main_loop $emailOne $emailTwo
            echo "Press any key to continue..."
            read -n 1 -s
        fi
    done

else
    echo "Skipping email verification..."
fi
