#!/bin/bash

## functions 
create_user(){
    username=$1

    if id "$username" &> /dev/null; then
        #return 1
        echo "none"
    else 
        sudo useradd $username
        sudo mkdir /home/$username
        sudo chown $username:$username /home/$username
        password=$( pwgen -B -1 )
        sudo echo "$username:$password" | sudo chpasswd

        echo $password
    fi
}


send_email(){
    sendmail $1 << EOF
To: $1
From: Cyclobold Hosting <theoafactor@gmail.com>
Subject: $2

Your hosting details are as follows:
Username: $3
RAM: $4 GB
Storage: $5 GB  
Password: $6     
EOF
}


# Function to onboard a new user
while read line; 
do
    # Split the line into fields    
    if [[ $line != "SN,FirstName,LastName,AccountType,RAM,Storage,UserName,Status,Email" ]]
    then 
        sn=$(echo $line | cut -d',' -f1)
        firstname=$(echo $line | cut -d',' -f2)
        lastname=$(echo $line | cut -d',' -f3)
        accountType=$(echo $line | cut -d',' -f4)
        ram=$(echo $line | cut -d',' -f5)
        storage=$(echo $line | cut -d',' -f6)
        username=$(echo $line | cut -d',' -f7)
        status=$(echo $line | cut -d',' -f8)
        email=$(echo $line | cut -d',' -f9)

       
        if [[ $accountType == "Shared" ]]
        then 
            ## create shared account 
            result=$(create_user $username)

            if [[ $result == "none" ]]
            then
                echo "Account exists already..."
                echo "Moving on ..."

            else

                echo "Account created .."
                ## send email 
                send_email $email "Shared Account Created" $username $ram $storage $result
                
                sudo echo "User $username created successfully" >> /var/log/onboard.log
            fi
            
        
            

        elif [[ $accountType == "Dedicated" ]]
        then
            ## create dedicated account
            echo "Moving on .."
        fi



    fi

done < accounts.csv