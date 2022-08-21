#!/bin/bash -   
#title          :buildscript-3
#description    :create a script that will securely and automatically create a git user and push changes to any branch but main
#author         :Sasheeny Hubbard
#date           :08-20-2022
#version        :2      
#usage          :./buildscript-3v2.sh
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
 
printf "%s\n" "Enter the name the branch you're committing your changes from: " ; read -r src_branch

printf "%s\n" "Enter the name the branch you're committing your changes to: " ; read -r dest_branch

printf "%s\n" "Enter your commit message: " ; read -r commit_msg 

#printf "%s\n" "Enter the name of your repo project folder: " ; read -r project

# Create username
FIRST_NAME_INITIAL=$( echo $name1 | cut -c 1 | tr 'A-Z' 'a-z' )
LASTNAME=$( echo $name2 | tr 'A-Z' 'a-z' )

USERNAME="${FIRST_NAME_INITIAL}${LASTNAME}"


# Create user and add them to GitAcc group, if it doesn't already exist

#grep $username /etc/passwd || sudo useradd $username -g "${GROUP}"
if ! getent passwd "${USERNAME}" > /dev/null
then
    printf "%s\n" "User ${USERNAME} does not exist, creating it"
    sudo useradd "${USERNAME}" -g "${GROUP}"
fi

# Switch to src_branch if neccesary 

#if [ "$(git branch)" == $src_branch ];
#then
#	exit 0
#else 
#    git switch $src_branch
#    exit 0
#fi


# Look for references to social security in file(s) before git add/commit

keyword[1]="Social Security Number"
keyword[2]="Social Security #"
keyword[3]="SSN"
keyword[4]="SS#"
keyword[5]="SS #"
keyword[6]="SOCIAL SECURITY"
keyword[7]="social security"
keyword[8]="Social"

# Bold print

tput bold 

# Notice the use of double \n to create a new line.
for index in 1 2 3 4 5 6 7 8    # Eight keywords.
do
    #grep -iw "${keyword[index]}" "$project_dir/$file" || echo "The following sensitive data identified in your file. Remove flagged data before attempting to commit your file again."
    #if [ "$(grep -iw "${keyword[index]}" "${PROJECT_DIR}"/"$file")" != "" ];
    if ! grep -iw "${keyword[index]}" "${PROJECT_DIR}/$file" > /dev/null
    then
        printf "%s\n\n" "The following sensitive data, ${keyword[$index]}, has been identified in your file."
        printf "%s\n" "Remove flagged data before attempting to commit your file again."
        exit 1
    else
        printf "%s\n\n"Committing your changes...
        sleep 1
        printf "%s\n" Still working...
        git add "$file"
        git commit -m "$commit_msg on ${DATE}"
        sleep 2
        printf "%s\n" "SUCCESS! Your changes have been added and committed to $dest_branch."
        sleep 1
        printf "%s\n\n" "Retrieving oneline git log data summary"
        sleep 1
        git log --oneline
        sleep 2
        printf "%s\n" Goodbye now.
    fi
    exit 0
done
