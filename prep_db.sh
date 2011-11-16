#! /bin/bash

# prep_db.sh

INT=z

until [ "$INT" = "y" ]; do
	echo ""
	echo "Enter IP Address or Server name of your MySQL Server"
	read MYSQL
	echo "Please verify you entered the IP Address or Server Name correctly"
	read -s -n1 -p "Was this correct? (y/N) " INT
done
INT=z
echo ""
read -s -n1 -p  "Accept Default User and Database Names? (y/N)" INT
echo ""
if [ "$INT" = "y" ]; then
	GLANCE_DATABASE_NAME=glance
	GLANCE_DATABASE_USER=glance
	NOVA_DATABASE_NAME=nova
	NOVA_DATABASE_USER=nova
	KEYSTONE_DATABASE_NAME=keystone
	KEYSTONE_DATABASE_USER=keystone
	DASH_DATABASE_NAME=dash
	DASH_DATABASE_USER=dash
	SWIFT_DATABASE_NAME=swift
	SWIFT_DATABASE_USER=swift
	RABBIT_USER=hermod
else
	echo "Enter Glance Info:"
	echo -n "User Name?"
	read GLANCE_DATABASE_USER
		if [ -z "$GLANCE_DATABASE_USER" ]; then GLANCE_DATABASE_USER=glance; fi
	echo -n "Database Name?"
	read GLANCE_DATABASE_NAME
		if [ -z "$GLANCE_DATABASE_NAME" ]; then GLANCE_DATABASE_NAME=glance; fi

	echo "Enter Nova Info:"
	echo -n "User Name?"
	read NOVA_DATABASE_USER
		if [ -z "$NOVA_DATABASE_USER" ]; then NOVA_DATABASE_USER=nova; fi
	echo -n "Database Name?"
	read NOVA_DATABASE_NAME
		if [ -z "$NOVA_DATABASE_NAME" ]; then NOVA_DATABASE_NAME=nova; fi

	echo "Enter Keystone Info:"
	echo -n "User name?"
	read KEYSTONE_DATABASE_USER
		if [ -z "$KEYSTONE_DATABASE_USER" ]; then KEYSTONE_DATABASE_USER=keystone; fi
	echo -n "Database Name?"
	read KEYSTONE_DATABASE_NAME
		if [ -z "$KEYSTONE_DATABASE_NAME" ]; then KEYSTONE_DATABASE_NAME=keystone; fi

	echo "Enter Horizon/Dashboard Info:"
	echo -n "User Name?"
	read DASH_DATABASE_USER
		if [ -z "$DASH_DATABASE_USER" ];then DASH_DATABASE_USER=dash; fi
	echo -n "Database Name?"
	read DASH_DATABASE_NAME
		if [ -z "$DASH_DATABASE_NAME" ]; then DASH_DATABASE_NAME=dash; fi

        echo "Enter Swift Info:"
        echo -n "User Name?"
        read SWIFT_DATABASE_USER
                if [ -z "$SWIFT_DATABASE_USER" ]; then SWIFT_DATABASE_USER=swift; fi
        echo -n "Database Name?"
        read SWIFT_DATABASE_NAME
                if [ -z "$SWIFT_DATABASE_NAME" ]; then SWIFT_DATABASE_NAME=swift; fi

	echo "Enter a User name for the Rabbit messanger service"
	read RABBIT_USER_NAME
		if [ -z "$RABBIT_USER_NAME" ]; then RABBIT_USER=hermod; fi
fi

# Create "random" passwords
GLANCE_DATABASE_PASS=`openssl rand -hex 8`
NOVA_DATABASE_PASS=`openssl rand -hex 8`
KEYSTONE_DATABASE_PASS=`openssl rand -hex 8`
DASH_DATABASE_PASS=`openssl rand -hex 8`
SWIFT_DATABASE_PASS=`openssl rand -hex 8`
RABBIT_PASS=`openssl rand -hex 5`

echo "# glance MySQL" >> database
echo "GLANCE_DATABASE_NAME=$GLANCE_DATABASE_NAME" >> database
echo "GLANCE_DATABASE_USER=$GLANCE_DATABASE_USER" >> database
echo "GLANCE_DATABASE_PASS=$GLANCE_DATABASE_PASS" >> database
echo "GLANCE_DATABASE_HOST=$MYSQL" >> database
echo "" >> database

echo "# Nova MySQL" >> database
echo "NOVA_DATABASE_NAME=$NOVA_DATABASE_NAME" >> database
echo "NOVA_DATABASE_USER=$NOVA_DATABASE_USER" >> database
echo "NOVA_DATABASE_PASS=$NOVA_DATABASE_PASS" >> database
echo "NOVA_DATABASE_HOST=$MYSQL" >> database
echo "" >> database

echo "# Keystone MySQL" >> database
echo "KEYSTONE_DATABASE_NAME=$KEYSTONE_DATABASE_NAME" >> database
echo "KEYSTONE_DATABASE_USER=$KEYSTONE_DATABASE_USER" >> database
echo "KEYSTONE_DATABASE_PASS=$KEYSTONE_DATABASE_PASS" >> database
echo "KEYSTONE_DATABASE_HOST=$MYSQL" >> database
echo "" >> database

echo "# Dash MySQL" >> database
echo "DASH_DATABASE_NAME=$DASH_DATABASE_NAME" >> database
echo "DASH_DATABASE_USER=$DASH_DATABASE_USER" >> database
echo "DASH_DATABASE_PASS=$DASH_DATABASE_PASS" >> database
echo "DASH_DATABASE_HOST=$MYSQL" >> database
echo "" >> database

echo "# Swift MySQL" >> database
echo "SWIFT_DATABASE_NAME=$SWIFT_DATABASE_NAME" >> database
echo "SWIFT_DATABASE_USER=$SWIFT_DATABASE_USER" >> database
echo "SWIFT_DATABASE_PASS=$SWIFT_DATABASE_PASS" >> database
echo "SWIFT_DATABASE_HOST=$MYSQL" >> database
echo "" >> database


echo "# Rabbit Messanger Service" >> database
echo "RABBIT_USER=$RABBIT_USER" >> database
echo "RABBIT_PASS=$RABBIT_PASS" >> database
echo "" >> database

echo "This information is in a file called \"database\""
echo "You may need to use the information in this file"
echo "if you install services on other servers"
echo ""
echo "Please hit <ENTER> to continue"
read DUMMY

exit 0


