#!/bin/bash

# Check if argument is provided
if [ -z $1 ];

# If no argument is provided, instruct user to include an ip address as an argmument
then 
	echo "You need to enter an ip address as an argument"

# Otherwise the argumement provided is saved as the variable dir
else
	IP=$1
fi

# _________________

# for loop to check if the server is online
for ip in $IP
do
    ping -c 3 $IP
    if [ $(echo $?) -eq 0 ]
    then
	echo "  "
        echo pong: Conection made!
        break
    fi
done

ssh -i ~/.ssh/Cali1.pem ubuntu@$IP

exit 0
