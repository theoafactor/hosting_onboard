#!/bin/bash

# sendmail theoafactor@gmail.com << EOF
# To: theoafactor@gmail.com
# From: theoafactor@gmail.com
# Subject: Test Email

# This is a test email sent from the script
# EOF


check_user(){
    echo "Working"
    echo "Welcome $1"

    return 2
}

check_user james
echo $?
 

