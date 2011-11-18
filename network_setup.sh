#! /bin/bash
# Set up the network

###############
#             #
# this is for #
# FLAT DHCP   #
# Networking  #
#   ONLY      #
#             #
###############

#echo "Name your network"
#read NETWORK_NAME
#echo "Too bad...We are going with 'private' instead"
#      We will add this feature in when further testing permits
NETWORK_NAME=private
echo "Network for this project has been named $NETWORK_NAME"

echo "Enter Fixed Network range [ie 10.10.10.0/24 ]"
read FIXED_IPS

echo "We are setting number of networks to '1' "
echo "because we are currently setting up flat networking"
# echo number of networks for this range
# read NET_NUM
NET_NUM=1
echo "Number of networks has been set to $NET_NUM"

echo "Enter number of IP's [PER NETWORK] in that range"
read IPS

nova-manage network create $NETWORK_NAME $FIXED_IPS $NET_NUM $IPS

echo "Network $NETWORK_NAME created with $IPS IPs in $FIXED_IPS range"

echo "Enter Floating IP range [ie 192.168.15.224/27]"
read FLOATING

sudo nova-manage floating create --ip_range=$FLOATING

echo "Floating IP's created"

exit 0

