#! /bin/bash
# Build the nova-settings file
touch nova-settings
. database
# Create a function to add flags to nova-settings file
function add_nova_flag {
    echo "$1" >> nova-settings
}

echo "Enter Host IP"
read MY_HOST

ANSWER=z
until [ "$ANSWER" = "y" -o "$ANSWER" = "n" ]; do
echo "Are all services on the same machine?"
read ANSWER
	case $ANSWER in
	y )
	NOVA_HOST_IP=$MY_HOST
	KEYSTONE_HOST_IP=$MY_HOST
	GLANCE_HOST_IP=$MY_HOST
	RABBIT_HOST_IP=$MY_HOST
	;;
	n )
	echo "Enter your Nova Host IP"
	read NOVA_HOST_IP
	echo "Enter your Glance Server IP"
	read GLANCE_HOST_IP
	echo "Enter your Keystone Server IP"
	read KEYSTONE_HOST_IP
	echo "Enter your Rabbit Messanger Server IP"
	read RABBIT_HOST_IP
	;;
	* ) echo "Please enter y for YES or n for NO" ;;
	esac
done
TESTER=z
until [ -z "$TESTER" ]; do
	echo "1)NOVA HOST is $NOVA_HOST_IP"
	echo "2)RABBIT HOST is $RABBIT_HOST_IP"
	echo "3)GLANCE HOST is $GLANCE_HOST_IP"
	echo "4)KEYSTONE HOST $KEYSTONE_HOST_IP"
	echo "press <ENTER> to continue"
	echo "or the number to correct"
	read TESTER
	case $TESTER in
		1 ) echo "Enter your Nova Host IP"
	        read NOVA_HOST_IP ;;
	        2 ) echo "Enter your Rabbit Messanger Server IP"
	        read RABBIT_HOST_IP ;;
		3 ) echo "Enter your Glance Server IP"
	        read GLANCE_HOST_IP ;;
	        4 ) echo "Enter your Keystone Server IP"
	        read KEYSTONE_HOST_IP ;;
	esac
done

if [ -f server-path ];then
	rm server-path
fi

touch server-path
echo "NOVA_HOST_IP=$NOVA_HOST_IP" >> server-path
echo "KEYSTONE_HOST_IP=$KEYSTONE_HOST_IP" >> server-path
echo "GLANCE_HOST_IP=$GLANCE_HOST_IP" >> server-path
echo "RABBIT_HOST_IP=$RABBIT_HOST_IP" >> server-path

# Add database flag to nova-settings
add_nova_flag "## Where is Nova?"
add_nova_flag "--logdir=/var/log/nova"
add_nova_flag "--state_path=/var/lib/nova"
add_nova_flag "--lock_path=/var/lock/nova"
add_nova_flag "--state_path=/var/lib/nova"
add_nova_flag "--verbose"
add_nova_flag "--sql_connection=mysql://$NOVA_DATABASE_USER:$NOVA_DATABASE_PASS@$NOVA_HOST_IP/$NOVA_DATABASE_NAME"
add_nova_flag ""

add_nova_flag "## Set default behaviour"
add_nova_flag "--force_dhcp_release=True"
add_nova_flag "--resume_guests_state_on_host_boot=true"
add_nova_flag "--allow_admin_api=true"
add_nova_flag ""

add_nova_flag "## Where are the Services?"
add_nova_flag "--glance_api_servers=$GLANCE_HOST_IP:9292"
add_nova_flag "--s3_host=$GLANCE_HOST_IP"
add_nova_flag "--s3_dmz=$GLANCE_HOST_IP"
add_nova_flag "--rabbit_host=$RABBIT_HOST_IP"
add_nova_flag "--rabbit_password=$RABBIT_PASS"
add_nova_flag "--rabbit_userid=$RABBIT_USER"
add_nova_flag "--ec2_url=http://$NOVA_HOST_IP:8773/services/Cloud"
add_nova_flag "--ec2_dmz_host=$NOVA_HOST_IP"
add_nova_flag "--nova_url=http://$NOVA_HOST_IP:8774/v1.1/"
add_nova_flag "--ajax_console_proxy_url=http:$NOVA_HOST_IP//:8000"
add_nova_flag "--osapi_host=$NOVA_HOST_IP"
add_nova_flag "#--keystone_ec2_url=$KEYSTONE_HOST_IP:5000/v2.0/ec2tokens"
add_nova_flag "--iscsi_ip_prefix=10.10."
add_nova_flag "--iscsi_helper=tgtadm"
add_nova_flag "--image_service=nova.image.glance.GlanceImageService"
add_nova_flag "#--FAKE_subdomain=ec2"
add_nova_flag ""

add_nova_flag "## Networking"
add_nova_flag "--dhcpbridge_flagfile=/etc/nova/nova.conf"
add_nova_flag "--dhcpbridge=/usr/bin/nova-dhcpbridge"
add_nova_flag "--network_manager=nova.network.manager.FlatDHCPManager"
add_nova_flag "--fixed_range=10.10.0.0/16"
add_nova_flag "--network_size=8"
add_nova_flag "--routing_source_ip=$MY_HOST"
add_nova_flag "--flat_network_dhcp_start=10.10.10.2"
add_nova_flag "--flat_network_bridge=br100"
add_nova_flag "--flat_interface=eth0"
add_nova_flag "--flat_injected=False"
add_nova_flag "--public_interface=eth0"


# Add with vnc proxy service
#add_nova_flag "--vncproxy_wwwroot=/opt/noVNC"
#add_nova_flag "--vncproxy_port=6080"
#add_nova_flag "--vncproxy_host=192.168.15.199"

exit 0
