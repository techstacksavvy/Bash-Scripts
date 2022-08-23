#!/bin/bash

# Script to send files remotely from one server to another


if [ -z $1 ];
then
	echo "you need to enter an ip address as an argument"
else
	IP=$1
fi

echo "enter the file path of the document you're sending: "
read FILE_PATH

scp -i ~/.ssh/Cali1.pem $FILE_PATH ubuntu@$IP:/home/ubuntu

exit 0
