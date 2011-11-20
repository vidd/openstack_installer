#!/bin/bash
# keystone_template
echo "Restarting Keystone"
service keystone restart
echo "Giving Keystone a moment to recover"
sleep 5
echo "Now back to work"

if [ ! -f database ]; then
	echo "Databases are not ready"
	exit 1
else
	. database
fi

if [ ! -f server-path ]; then
	./prep_sp.sh
fi
. server-path

if [ -z $AUTH_TOKEN ]; then
AUTH_TOKEN=`pwgen -cns 16 1`
echo "AUTH_TOKEN=$AUTH_TOKEN" >> server-path
fi
echo "AUTH_TOKEN=$AUTH_TOKEN"
if [ -z $ADMIN_PASSWORD ]; then
echo "Enter username Keystone Administrator"
read ADMIN_USER
	if [ -z $ADMIN_USER ]; then ADMIN_USER=admin ; fi
echo "ADMIN_USER=$ADMIN_USER" >> server-path
fi

if [ -z $ADMIN_PASSWORD ]; then
PASS1=TheAnswer
PASS2=42
until [ "$PASS1" = "$PASS2" ]; do
	echo "Enter password Keystone Administrator"
	read -s PASS1
	echo "Re-enter password"
	read -s PASS2
		if [ "$PASS1" != "$PASS2" ]; then echo "Passwords do not match!" ; fi
done
ADMIN_PASSWORD=$PASS1
echo "ADMIN_PASSWORD=$ADMIN_PASSWORD" >> server-path
fi

cmd=keystone-manage

# Tenant
$cmd tenant add admin

# User
$cmd user add $ADMIN_USER $ADMIN_PASSWORD admin

# Roles
$cmd role add Admin
$cmd role add Member
$cmd role add KeystoneAdmin
$cmd role add KeystoneServiceAdmin

# Add User to Role
$cmd role grant Admin $ADMIN_USER admin
$cmd role grant Admin $ADMIN_USER
$cmd role grant KeystoneAdmin $ADMIN_USER
$cmd role grant KeystoneServiceAdmin $ADMIN_USER

# Services
$cmd service add nova compute "Nova Compute Service"
$cmd service add glance image "Glance Image Service"
$cmd service add keystone identity "Keystone Identity Service"

#endpointTemplates
$cmd endpointTemplates add RegionOne glance http://$GLANCE_HOST_IP:9292/v1.0/images http://$GLANCE_HOST_IP:9292/v1.0/images http://$GLANCE_HOST_IP:9292/v1.0/images 1 0
$cmd endpointTemplates add RegionOne nova http://$NOVA_HOST_IP:8774/v1.1/%tenant_id% http://$NOVA_HOST_IP:8774/v1.1/%tenant_id% http://$NOVA_HOST_IP:8774/v1.1/%tenant_id% 1 0
$cmd endpointTemplates add RegionOne keystone http://$KEYSTONE_HOST_IP:5000/v2.0/ http://$KEYSTONE_HOST_IP:35357/v2.0/ http://$KEYSTONE_HOST_IP:5000/v2.0 1 1
#$cmd endpointTemplates add RegionOne swift https://$SWIFT_HOST_IP:8080/v1/AUTH_%tenant_id% https://$SWIFT_HOST_IP:8080/ https://$SWIFT_HOST_IP:8080/v1/AUTH_%tenant_id% 1 0

# Tokens
$cmd token add $AUTH_TOKEN $ADMIN_USER admin 2015-02-05T00:00

# EC2 related creds - note we are setting the token to user_password
# but keystone doesn't parse them - it is just a blob from keystone's
# point of view
$cmd  credentials add admin EC2 $ADMIN_USER:$ADMIN_PASSWORD $ADMIN_USER admin

exit 0
