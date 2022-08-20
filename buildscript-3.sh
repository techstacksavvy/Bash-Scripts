#!/bin/bash -   
#title          :buildscript-3.sh
#description    :create a script that will securely and automatically create a git user and push changes to any branch but main
#author         :Sasheeny Hubbard
#date           :08-14-2022
#version        :1      
#usage          :./buildscript-3.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

# Create GitAcc group if it doesn't exist

grep GitAcc /etc/group || sudo groupadd GitAcc

group=GitAcc

# Collect information from the user

printf "%s\n" "What is your first and last name? " ; read -r name1 name2

printf "%s\n" "Enter the name of the file you want to commit: " ; read -r file
 
printf "%s\n" "Enter the name the branch you're committing your changes from: " ; read -r src_branch

printf "%s\n" "Enter the name the branch you're committing your changes to: " ; read -r dest_branch

printf "%s\n" "Enter your commit message: " ; read -r commit_msg 

#printf "%s\n" "Enter the name of your repo project folder: " ; read -r project

name1=$( echo $name1 | cut -c 1 | tr 'A-Z' 'a-z' )
name2=$( echo $name2 | tr 'A-Z' 'a-z' )

username="${name1}${name2}"
date=$(date)
project_dir="/home/sasheenyhubbard/kura/test_repo2"

# Create user and add them to GitAcc group, if it doesn't already exist

grep $username /etc/passwd || sudo useradd $username -g $group

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

for index in 1 2 3 4 5 6 7 8    # Eight keywords.
do
    #grep -iw "${keyword[index]}" "$project_dir/$file" || echo "The following sensitive data identified in your file. Remove flagged data before attempting to commit your file again."
    if [ "$(grep -iw "${keyword[index]}" "$project_dir"/"$file")" != "" ];
    then
        echo "The following sensitive data, ${keyword[$index]}, has been identified in your file."
        echo " "
        echo "Remove flagged data before attempting to commit your file again."
        exit 1
    else
        echo Committing your changes...
        sleep 1
        echo " "
        echo Still working...
        git add "$file"
        git commit -m "$commit_msg on $date"
        sleep 2
        echo "SUCCESS! Your changes have been added and committed to ""$dest_branch""."
        sleep 1
        echo Retrieving oneline git log data summary
        sleep 1
        git log --oneline
        sleep 2
        echo ""
        echo Goodbye now.
    fi
    exit 0
done


