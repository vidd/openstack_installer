#! /bin/bash

# Setup Nova Manage Stuff
#nova-manage db sync

while [ -z "$NOVAADMIN" ]; do
	echo "Name your project manager"
	read NOVAADMIN
done
nova-manage user admin $NOVAADMIN

echo "Copy your EC2_ACCESS_KEY ... Your going to need it"

while [ -z "$PROJECT" ]; do
	echo "Name your project"
	read PROJECT
done
nova-manage project create $PROJECT $NOVAADMIN

mkdir ~/creds
nova-manage project zipfile $PROJECT $NOVAADMIN ~/creds/zipnovacreds.zip

unzip ~/creds/zipnovacreds.zip -d ~/creds
cp ~/creds/*.pem ~/

echo "Fix your EC2_ACCESS_KEY"
echo "by replacing 'EC2_ACCESS_KEY=$NOVAADMIN:$PROJECT'"
echo "with 'EC2_ACCESS_KEY=%accesskey%:$PROJECT'"
echo "Hit <ENTER> when ready"
read DUMMY
nano ~/creds/novarc
cat ~/creds/novarc >> ~/.bashrc

./network_setup.sh

exit=0


