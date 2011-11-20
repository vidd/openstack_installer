#! /bin/bash

if [ ! -f database ]; then
        echo "we need to create the \"database\" file"
        ./prep_db.sh

else echo "We shall use your existing database file"

fi

. database

#Setting up Nova

#Install Rabbit
echo "installing rabbit"
./rabbit.sh

echo "Installing Nova"

apt-get install -y nova-common nova-doc python-nova nova-api nova-network nova-volume \
nova-objectstore nova-scheduler nova-compute euca2ools unzip python-greenlet python-mysqldb \
nova-vncproxy nova-ajax-console-proxy 

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

# Create Nova Database
nova-manage db sync

# Restart all services
./restart_services.sh

# Finish setting up Nova
./eu_setup.sh

# Set up Nova-Volume
#./nova_volume.sh
echo "We are NOT setting up Nova-Volumes at this time"
echo "You need to have an LVM drive set up"
echo "Once the LVM drive is ready, you can run the"
echo "nova_volume.sh script to configure the drive"
echo ""
echo ""

echo "To enable EUCA CLI you must"
echo "source your novarc file"
echo ""
echo ""
echo "Please hit <ENTER> to continue"
read DUMMY

exit 0

