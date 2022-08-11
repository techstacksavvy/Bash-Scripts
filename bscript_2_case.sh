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
	
    echo The processes listed 'in' the table above exceed the maximum allowed memory usage and must therefore be terminated. 
	echo Proceed to terminate these processes with the following command, kill '<pid> [...]'
	
	read -p "Enter the PID number(s) of all non-essential processes from the table above, each with a space in between them: " pid
	#read -p "Are you sure you want to terminate these processes? " ans
fi


echo Are you sure you want to terminate these processes?

read ans 

case $ans in 
y | yes)
	kill $pid
	;;

n|no)
	echo Okay.
	echo Goodbye.
	;;
*)
    echo "Invalid entry. Enter yes/(y) or no/(n)"
    ;;
esac

#ps aux | $ans
#echo "Process $ans has been terminated."

exit 0
