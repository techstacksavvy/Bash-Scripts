#!/bin/bash

# BuildScript, bscript_1.sh, created by Sasheeny Hubbard on August 4, 2022.
# The purpose of this script is to auto update software packages on the server 
# without any user interaction.

# Cron job: To auto update the server(s) weekly on Friday at 11 P.M. 
# 0 23 * * 5 root bscript_1.sh

# Run script as Root or Superuser

if [ $UID != 0 ];
then 
	echo execute as Root
fi

# Run Apt Update to get a list of packages on the server eligible for a package upgrade

while [ $UID = 0 ];
 do
	apt update -y
	continue
done

# Run Apt Upgrade to get the lastest version of eligible software packages on the server(s) and
# Save results of daily software package updates to a file with appended date in the user $HOME directory

while [ $UID = 0 ];
 do
	apt upgrade -y >> ${HOME}/updated_packages-"`date +"%d-%m-%Y"`".txt

	continue
done

# Save results of daily software package updates to a file with appended date in the user $HOME directory
#grep -w upgrade /var/log/dpkg.log >> ${HOME}/updated_packages-"`date +"%d-%m-%Y"`".txt

exit 0
