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
            sudo echo "$username:$username" | sudo chpasswd
            sudo echo "User $username created successfully" >> /var/log/onboard.log

        elif [[ $accountType == "Dedicated" ]]
        then
            ## create dedicated account
            echo "Moving on .."
        fi



    fi

done < accounts.csv