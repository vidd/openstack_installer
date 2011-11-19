#! /bin/bash
#./user_add_keystone.sh

. server-path
. ~/creds/novarc

$cmd tenant add $NOVA_PROJECT_ID
$cmd user add $NOVA_USERNAME $NOVA_API_KEY $NOVA_PROJECT_ID
$cmd role grant Member $NOVA_USERNAME $NOVA_PROJECT_ID
$cmd role grant Admin $NOVA_USERNAME 
$cmd role grant KeystoneServiceAdmin $NOVA_USERNAME $NOVA_PROJECT_ID
$cmd credentials add $NOVA_USERNAME EC2 $EC2_ACCESS_KEY $EC2_SECRET_KEY $NOVA_PROJECT_ID


exit o