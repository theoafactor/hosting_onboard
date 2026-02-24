#!/bin/bash

# Function to onboard a new user
while read line; 
do
    # Split the line into fields    
    if [[ $line != "SN,FirstName,LastName,AccountType,RAM,Storage,UserName,Status" ]]
    then 
        sn=$(echo $line | cut -d',' -f1)
        firstname=$(echo $line | cut -d',' -f2)
        lastname=$(echo $line | cut -d',' -f3)
        accountType=$(echo $line | cut -d',' -f4)
        ram=$(echo $line | cut -d',' -f5)
        storage=$(echo $line | cut -d',' -f6)
        username=$(echo $line | cut -d',' -f7)
        status=$(echo $line | cut -d',' -f8)

       
        if [[ $accountType == "Shared" ]]
        then 
            ## create shared account 
            sudo useradd $username
            sudo mkdir /home/$username
            sudo chown $username:$username /home/$username
            password=$( pwgen -B -1 )
            sudo echo "$username:$password" | sudo chpasswd

            sendmail theoafactor@gmail.com << EOF
To: theoafactor@gmail.com
From: Cyclobold Hosting <theoafactor@gmail.com>
Subject: Your Hosting Details

Your hosting details are as follows:
Username: $username
RAM: $ram GB
Storage: $storage GB  
Password: $password      
EOF

            

            sudo echo "User $username created successfully" >> /var/log/onboard.log

        elif [[ $accountType == "Dedicated" ]]
        then
            ## create dedicated account
            echo "Moving on .."
        fi



    fi

done < accounts.csv