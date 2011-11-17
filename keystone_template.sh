#! /bin/bash

# Where are the Servers?
. server-path
. ~/creds/novarc
# Preload variables
TEMP_PASS1=TheANSWER
TEMP_PASS2=42
INST_PROMPT=z
echo "Enter a name for your Nova Administrator"
read HORIZON_USER

until [ "$TEMP_PASS1" = "$TEMP_PASS2" ]; do
        echo "Enter a password your Nova Administrator will use"
        echo "To access the Horizon Dashboard Utility"
        read -s TEMP_PASS1
        echo "Reenter password"
        read -s TEMP_PASS2
        if [ "$TEMP_PASS1" != "$TEMP_PASS2"  ]; then
                echo "Password does not match"
        fi
done
echo "Passwords match"

HORIZON_PASSWORD=$TEMP_PASS1
HORIZON_TENANT=Horizon

# Set a "random" password for internal services and auth-token
INT_SVCS_PASS=`openssl rand -hex 10`

if [ -z $AUTH_TOKEN ]; then
AUTH_TOKEN=`openssl rand -hex 10`
fi

cmd="keystone-manage"


# Roles
$cmd role add Admin # Admin role MUST have TENANT=NULL
$cmd role add KeystoneServiceAdmin
$cmd role add Member

# My test tenant user
$cmd tenant add $NOVA_PROJECT_ID
$cmd user add $NOVA_USERNAME $NOVA_API_KEY $NOVA_PROJECT_ID
$cmd role grant Member $NOVA_USERNAME $NOVA_PROJECT_ID
$cmd role grant Admin $NOVA_USERNAME 
$cmd role grant KeystoneServiceAdmin $NOVA_USERNAME $NOVA_PROJECT_ID
$cmd credentials add $NOVA_USERNAME EC2 $EC2_ACCESS_KEY $EC2_SECRET_KEY $NOVA_PROJECT_ID

# Our Horizon user
$cmd tenant add $HORIZON_TENANT
$cmd user add $HORIZON_USER $HORIZON_PASSWORD $HORIZON_TENANT
$cmd role grant Member $HORIZON_USER $HORIZON_TENANT
$cmd credentials add $HORIZON_USER EC2 $HORIZON_USER:$HORIZON_USER $HORIZON_PASSWORD $HORIZON_TENANT


# Internal services tenant
$cmd tenant add int_svcs
# User used for glance > swift
$cmd user add glance $INT_SVCS_PASS int_svcs
$cmd role grant Member glance

$cmd service add glance image "Image service"
$cmd service add nova compute "Nova compute"
$cmd service add keystone identity "Identity service"
#$cmd service add swift object-store "Swift object-store"

$cmd endpointTemplates add RegionOne glance http://$GLANCE_HOST_IP:9292/v1.0/images http://$GLANCE_HOST_IP:9292/v1.0/images http://$GLANCE_HOST_IP:9292/v1.0/images 1 0
$cmd endpointTemplates add RegionOne nova http://$NOVA_HOST_IP:8774/v1.1/%tenant_id% http://$NOVA_HOST_IP:8774/v1.1/%tenant_id% http://$NOVA_HOST_IP:8774/v1.1/%tenant_id% 1 0
$cmd endpointTemplates add RegionOne keystone http://$KEYSTONE_HOST_IP:5000/v2.0/ http://$KEYSTONE_HOST_IP:35357/v2.0/ http://$KEYSTONE_HOST_IP:5000/v2.0 1 1
#$cmd endpointTemplates add RegionOne swift https://$SWIFT_HOST_IP:8080/v1/AUTH_%tenant_id% https://$SWIFT_HOST_IP:8080/ https://$SWIFT_HOST_IP:8080/v1/AUTH_%tenant_id% 1 0

$cmd endpoint add $NOVA_PROJECT_ID 1
$cmd endpoint add $NOVA_PROJECT_ID 2
$cmd endpoint add $NOVA_PROJECT_ID 3
# $cmd endpoint add $NOVA_PROJECT_ID 4

$cmd endpoint add $HORIZON_TENANT 1
$cmd endpoint add $HORIZON_TENANT 2
$cmd endpoint add $HORIZON_TENANT 3
# $cmd endpoint add $HORIZON_TENANT 4

$cmd endpoint add int_svcs 1
$cmd endpoint add int_svcs 2
$cmd endpoint add int_svcs 3
#$cmd endpoint add int_svcs 4

# Create your auth token
$cmd token add $AUTH_TOKEN $NOVA_USERNAME $NOVA_PROJECT_ID 2015-02-05T00:00

# Add your AUTH_TOKEN to Glance and Nova and add it to your environment
export AUTH_TOKEN=$AUTH_TOKEN
echo "export AUTH_TOKEN=$AUTH_TOKEN" >> ~/creds/novarc
echo "export AUTH_TOKEN=$AUTH_TOKEN" >> ~/.bashrc
echo "AUTH_TOKEN=$AUTH_TOKEN" >> server-path

echo "Your auth-token is $AUTH_TOKEN"
echo "Please make a note of it"

until [ "$INST_PROMPT" = "y" -o "$INST_PROMPT" = "n" ]; do
echo "Do you wish to enable Keystone at this time?"
read INST_PROMPT
case $INST_PROMPT in
y ) ./convert_keystone.sh ;;
n ) echo "Run the convert_keystone script when ready" ;;
* ) echo "Please enter 'y' for YES or 'n' for NO" ;;
esac
done

exit 0

