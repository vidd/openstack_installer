#! /bin/bash
# Install script

# Run as ROOT
if [ $(id -u) != "0" ]; then
    echo "Run this as root"
    exit 1
fi
INST_PROMPT=z
#clear

touch nova-settings

# Install the basics
#./basics.sh
until [ "$INST_PROMPT" = "y" -o "$INST_PROMPT" = "n" ]; do
	echo "Do you wish to install the basics at this time?"
	read INST_PROMPT
	case $INST_PROMPT in
	        y ) ./basics.sh ;;
	        n ) echo "Run the basics.sh script when ready" ;;
		0 ) exit ;;
	        * ) echo "Please enter 'y' for YES or 'n' for NO" ;;
	esac
done
INST_PROMPT=z
#clear


# Prepare the database file
#./prep_db.sh
if [ ! -f database ]; then
	./prep_db.sh

else echo "We shall use your existing database file"

fi

#set up databases
#./build_databases.sh
until [ "$INST_PROMPT" = "y" -o "$INST_PROMPT" = "n" ]; do
	echo "Do you wish to build databases at this time?"
	read INST_PROMPT
	case $INST_PROMPT in
	        y ) ./build_databases.sh ;;
	        n ) echo "Run the build_databases.sh script when ready";;
		0 ) exit ;;
	        * ) echo "Please enter 'y' for YES or 'n' for NO" ;;
	esac
done
INST_PROMPT=z
#clear


#Install Rabbit
#./rabbit.sh
until [ "$INST_PROMPT" = "y" -o "$INST_PROMPT" = "n" ]; do
	echo "Do you wish to install RabbitMQ at this time?"
	read INST_PROMPT
	case $INST_PROMPT in
	        y ) ./rabbit.sh ;;
	        n ) echo "Run the rabbit.sh script when ready" ;;
		0 ) exit ;;
	        * ) echo "Please enter 'y' for YES or 'n' for NO" ;;
	esac
done
INST_PROMPT=z
#clear


# Set up Glance
#./glance_setup.sh
until [ "$INST_PROMPT" = "y" -o "$INST_PROMPT" = "n" ]; do
	echo "Do you wish to install Glance at this time?"
	read INST_PROMPT
	case $INST_PROMPT in
	        y ) ./glance_setup.sh ;;
	        n ) echo "Run the glance_setup.sh script when ready" ;;
		0 ) exit ;;
	        * ) echo "Please enter 'y' for YES or 'n' for NO" ;;
	esac
done
INST_PROMPT=z
#clear

# Set up Nova
#./nova_setup.sh
until [ "$INST_PROMPT" = "y" -o "$INST_PROMPT" = "n" ]; do
	echo "Do you wish to install Nova at this time?"
	read INST_PROMPT
	case $INST_PROMPT in
	        y ) ./nova_setup.sh ;;
	        n ) echo "Run the nova_setup.sh script when ready" ;;
		0 ) exit ;;
	        * ) echo "Please enter 'y' for YES or 'n' for NO" ;;
	esac
done
INST_PROMPT=z
#clear

# Set up Keystone
#./keystone_setup.sh
until [ "$INST_PROMPT" = "y" -o "$INST_PROMPT" = "n" ]; do
	echo "Do you wish to install Keystone at this time?"
	read INST_PROMPT
	case $INST_PROMPT in
	        y ) ./keystone_setup.sh ;;
	        n ) echo "Run the keystone_setup.sh script when ready" ;;
		0 ) exit ;;
	        * ) echo "Please enter 'y' for YES or 'n' for NO" ;;
	esac
done
INST_PROMPT=z
#clear

# Input Keystone DataBase Info
#./keystone_template.sh
until [ "$INST_PROMPT" = "y" -o "$INST_PROMPT" = "n" ]; do
	echo "Do you wish to load the Keystone database at this time?"
	read INST_PROMPT
	case $INST_PROMPT in
	        y ) ./keystone_template.sh ;;
	        n ) echo "Run the keystone_template.sh script when ready" ;;
		0 ) exit ;;
	        * ) echo "Please enter 'y' for YES or 'n' for NO" ;;
	esac
done
INST_PROMPT=z
#clear

# Setup Horizon
#./horizon_setup.sh
until [ "$INST_PROMPT" = "y" -o "$INST_PROMPT" = "n" ]; do
	echo "Do you wish to install horizon at this time?"
	read INST_PROMPT
	case $INST_PROMPT in
	        y ) ./horizon_setup.sh ;;
	        n ) echo "Run the horizon_setup.sh script when ready" ;;
		0 ) exit ;;
	        * ) echo "Please enter 'y' for YES or 'n' for NO" ;;
	esac
done
INST_PROMPT=z
#clear

exit=0
