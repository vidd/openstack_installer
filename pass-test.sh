#! /bin/bash

########################
#                      #
#   Testing the logic  #
#    behind password   #
#      generation      #
#		       #
########################


TEMP_PASS1=TheANSWER
TEMP_PASS2=42

echo "Enter a password your Nova Administrator will use"
echo "To access the Horizon Dashboard Utility"
read -s TEMP_PASS1
echo "Reenter password"
read -s TEMP_PASS2

until [ "$TEMP_PASS1" = "$TEMP_PASS2" ]; do
        echo "Password does not match"
	echo "Try again"
	read -s TEMP_PASS1
	echo "Reenter password"
	read -s TEMP_PASS2
done
echo "Passwords match"

HORIZON_PASSWORD=$TEMP_PASS1

echo $HORIZON_PASSWORD

GLANCE_PASS=`openssl rand -hex 10`
echo $GLANCE_PASS
