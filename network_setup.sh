#! /bin/bash
# Set up the network

echo "Name your network"
read NETWORK_NAME
echo "Too bad...We are going with 'private' instead"
NETWORK_NAME=private
echo "Enter Fixed Network range [ie 10.10.10.0/24 ]"
read FIXED_IPS

echo "Enter number of IP's in that range"
read IPS

nova-manage network create $NETWORK_NAME $FIXED_IPS 1 $IPS

echo "Network "$NETWORK_NAME " created with "$IPS " IPs in "$FIXED_IPS" range"

echo "Enter Floating IP range [ie 192.168.15.224/27]"
read FLOATING

sudo nova-manage floating create --ip_range=$FLOATING

echo "Floating IP's created"

exit=0

