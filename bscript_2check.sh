#!/bin/bash

# Build Script #2 created by Sasheeny Hubbard on August 8, 2022
# The main objective is to create a script that will automatically check the server's 
# processes and system performance to analyze system resources and stop any non-essential 
# processes to the organization.  

# Create a variable that look at all the processes running on the server and identify processes using X amount of resources

performance=$(ps aux | awk -F " " ' $4 > 1.0 { print $2, $4, $1, $11 }' | sort -r -nk 2 | column -t -N "PID, MEM%, USER, CMD")

# Convert memory from kB to mB
#memory=$(grep MemTotal /proc/meminfo | awk ' { print $2 / "1000" } ')

if [ "$performance" == "" ];
then 
	echo Your system resources are appropriately distributed. 
	echo No further action is needed at this time.
else	
	echo "$performance"
	echo "                                                                 "
	
    # Ask user to terminate processes identifoed as using more that X amount of resources
	
    echo The processes listed 'in' the above table exceed the maximum allowed memory usage and must therefore be terminated. 
	echo Proceed to terminate these processes with the following command, kill '<pid> [...]'
	
    # Ask user to terminate processes identifoed as using more that X amount of resources
	
    echo The processes listed 'in' the above table exceed the maximum allowed memory usage and must therefore be terminated. 
	echo Proceed to terminate these processes with the following command, kill '<pid> [...]'
	
	read -p "Enter the PID(s), with spaces between them, from the table: " pid
	read -p "Are you sure you want to terminate these processes? " ans
fi

if [ "$ans" == "yes" ];
then 
	kill "$pid"
	echo "$performance"
    exit 0
elif [ "$ans" == "no" ]; 
then 
	echo Goodbye.
    exit 0
else [ "$ans" == "*" ]
    echo Please enter yes or no
    exit 0
fi
