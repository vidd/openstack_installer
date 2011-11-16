#! /bin/bash

. database

#Setting up Nova

echo "Installing Nova"
./rabbit.sh
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
./nova_volume.sh

# Create Nova Database
nova-manage db sync

# Restart all services
./restart_services.sh

# Finish setting up Nova
./eu_setup.sh


exit 0

