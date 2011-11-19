#! /bin/bash

. database

#Setting up Nova

echo "Installing Nova"

apt-get install -y nova-common nova-doc python-nova nova-api nova-network nova-volume \
nova-objectstore nova-scheduler nova-compute euca2ools unzip

echo "Creating custom settings"
./nova-preload.sh
cat nova-settings >> /etc/nova/nova.conf2
mv /etc/nova/nova.conf2 /etc/nova/nova.conf
echo "Moved custom settings"

# Install iscsitarget
echo "Installing iscsitarget"
apt-get -y install iscsitarget iscsitarget-dkms
sed -i 's/false/true/g' /etc/default/iscsitarget
service iscsitarget restart

# Give everything to Nova
chown -R root:nova /etc/nova
chmod 644 /etc/nova/nova.conf

# Set up Nova-Volume
#./nova_volume.sh
until [ "$INST_PROMPT" = "y" -o "$INST_PROMPT" = "n" ]; do
	echo "Do you wish to assign nova volume drive at this time?"
	read INST_PROMPT
	case $INST_PROMPT in
	        y ) ./nova_volume.sh ;;
	        n ) echo "Run the nova_setup.sh script when ready" ;;
		0 ) exit ;;
	        * ) echo "Please enter 'y' for YES or 'n' for NO" ;;
	esac
done
INST_PROMPT=z
#clear


# Create Nova Database
nova-manage db sync

# Restart all services
./restart_services.sh

# Finish setting up Nova
./eu_setup.sh


exit 0

