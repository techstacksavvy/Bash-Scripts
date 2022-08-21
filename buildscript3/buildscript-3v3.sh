#!/bin/bash -   
#title          :buildscript-3
#description    :create a script that will securely and automatically create a git user and push changes to any branch but main
#author         :Sasheeny Hubbard
#date           :08-21-2022
#version        :3      
#usage          :./buildscript-3v3.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

# Create GitAcc group if it doesn't exist

# Define required variables
GROUP="GitAcc"
DATE=$(date)
PROJECT_DIR="${HOME}/kura/test_repo2"

# Ensure project directory exists
if [ ! -d "${PROJECT_DIR}" ]
then
    printf "%s\n" "Project directory does not exist. Creating..."
    mkdir -p "${PROJECT_DIR}"
fi

# Below and showing two ways to check if something exist in a file
# The grep option is universal and the example below is a best practice
# way of using it in a bash script

# GETENT OPTION
# Create GitAcc group if it doesn't exist
# This option uses getent to check if the group exists
if ! getent group "${GROUP}" > /dev/null
then
    printf "%s\n" "Group ${GROUP} does not exist, creating it"
    sudo groupadd "${GROUP}"
fi

# GREP OPTION
# This option uses grep to check if the group exists
# this is wrapped in a if statement, the exclamation point is used to negate the grep output
# if the group doesn't exist, the group is created
if ! grep "${GROUP}" /etc/group > /dev/null
then
    printf "%s\n" "Group ${GROUP} does not exist, creating it"
    sudo groupadd "${GROUP}"
fi


# Collect information from the user

printf "%s\n" "What is your first and last name? " ; read -r name1 name2

printf "%s\n" "Enter the name of the file you want to commit: " ; read -r file
 
printf "%s\n" "Enter the name the branch you're committing your changes to: " ; read -r dest_branch

printf "%s\n" "Enter your commit message: " ; read -r commit_msg

printf "\n"

# Clear terminal

/usr/bin/clear 

# Create username

FIRST_NAME_INITIAL=$( echo $name1 | cut -c 1 | tr 'A-Z' 'a-z' )
LASTNAME=$( echo $name2 | tr 'A-Z' 'a-z' )

USERNAME="${FIRST_NAME_INITIAL}${LASTNAME}"


# Create user and add them to GitAcc group, if it doesn't already exist

if ! getent passwd "${USERNAME}" > /dev/null
then
    printf "%s\n" "User ${USERNAME} does not exist, creating it..."
    sudo useradd "${USERNAME}" -g "${GROUP}"
    printf "\n%s\n" "${USERNAME} has been created and added to the ${GROUP} group."
fi
sleep 2

# Look for references to social security in file(s) before git add/commit

keyword=( "Social Security Number" "Social Security #" "SSN" "SS#" "ss #" "SOCIAL SECURITY" "social security" "Social" )

if ! ls -l secheck.txt;
then
    printf "%s\n" "${keyword[@]}" > secheck.txt
fi

/usr/bin/clear

# Info security check 

printf "%s\n\n" "Performing information security check on $file..."
sleep 2

# Bold print

tput bold 

# Notice the use of double \n to create a new line.
    if grep -oFf secheck.txt $file 
    then
	printf "\n"
	# need to figure out how to print output with color with printf
        echo -e "\e[1;31m ALERT!!! Sensitive data detected!\e[0m"
        printf "\n%s\n\n" "Remove flagged data before attempting to commit "$file" again."
    else
	printf "%s\n\n" "Committing your changes..."
        sleep 1
        printf "%s\n\n" "Still working..."
        git add "$file"
        git commit -m "$commit_msg on ${DATE}"
        sleep 2
	# need to figure out how to print output with color with printf
	echo -e "\e[1;32m SUCCESS!\e[0m Your changes have been added and committed to $dest_branch."
	printf "\n"	
        sleep 1
        printf "%s\n\n" "Retrieving oneline git log data summary..."
        sleep 1
        git log --oneline
        sleep 2
        printf "\n\n%s\n" "Goodbye now."
	exit 0
    fi
