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
glance -A $AUTH_TOKEN show 2
(glance -A $AUTH_TOKEN index && echo "Success" ) || echo "Failed"
