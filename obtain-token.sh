#!/bin/bash

######################
#                    #
#  This script is a  #
#  modified version  #
#  of KIALLs script  #
# with the same name #
#                    #
######################

# Import Settings
. server-path

REQUEST="{\"auth\": {\"passwordCredentials\": {\"username\": \"$ADMIN_USER\", \"password\": \"$ADMIN_PASSWORD\"}}}"

RAW_TOKEN=`curl -s -d "$REQUEST" -H "Content-type: application/json" "http://$KEYSTONE_HOST_IP:5000/v2.0/tokens"`

# Uncomment next three lines are for troubleshooting issues

#echo "RAW_TOKEN=$RAW_TOKEN"
#echo "Press <ENTER> to continue"
#read DUMMY

TOKEN=`echo $RAW_TOKEN | python -c "import sys; import json; tok = json.loads(sys.stdin.read()); print tok['access']['token']['id'];"`

echo $TOKEN
