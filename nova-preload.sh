#! /bin/bash
# Build the nova-settings file

if [ ! -f server-path ];then
	./prep_sp.sh
fi

touch nova-settings

. database
. server-path

# Create a function to add flags to nova-settings file
function add_nova_flag {
    echo "$1" >> nova-settings
}

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
add_nova_flag "--ajax_console_proxy_url=http://$NOVA_HOST_IP:8000"
add_nova_flag "--osapi_host=$NOVA_HOST_IP"
add_nova_flag "#--keystone_ec2_url=http://$KEYSTONE_HOST_IP:5000/v2.0/ec2tokens"
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
add_nova_flag "--routing_source_ip=$NOVA_HOST_IP"
add_nova_flag "--flat_network_dhcp_start=10.10.10.2"
add_nova_flag "--flat_network_bridge=br100"
add_nova_flag "--flat_interface=eth0"
add_nova_flag "--flat_injected=False"
add_nova_flag "--public_interface=eth0"
add_nova_flag ""

add_nova_flag "## VNC Proxy Service"
add_nova_flag "--vncproxy_url=http://$NOVA_HOST_IP:6080"
add_nova_flag "--vncproxy_host=0.0.0.0"

echo "Please hit <ENTER> to continue"
read DUMMY

exit 0

