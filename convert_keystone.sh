#! /bin/bash
# Convert Glance to use Keystone Auth

. server-path
~/creds/novarc

# Turn on Keystone for Glance
sed -i 's/pipeline = context registryapp/# pipeline = context registryapp/g' /etc/glance/glance-registry.conf
sed -i 's/# pipeline = authtoken keystone_shim context registryapp/pipeline = authtoken keystone_shim context registryapp/g' /etc/glance/glance-registry.conf
sed -e "s,127.0.0.1,$KEYSTONE_HOST_IP,g" -i /etc/glance/glance-registry.conf
sed -e 's/5001/53537/g' /etc/glance/glance-registry.conf
sed -i 's/pipeline = versionnegotiation context apiv1app/# pipeline = versionnegotiation context apiv1app/g' /etc/glance/glance-api.conf
sed -i 's/# pipeline = versionnegotiation authtoken context apiv1app/pipeline = versionnegotiation authtoken context apiv1app/g' /etc/glance/glance-api.conf
sed -e "s,127.0.0.1,$KEYSTONE_HOST_IP,g" -i /etc/glance/glance-api.conf
sed -i 's/5001/53537/g' /etc/glance/glance-api.conf

# Turn on Keystone for Nova
cat api-paste-nova >> /etc/nova/api-paste.ini2
mv /etc/nova/api-paste.ini2 /etc/nova/api-paste.ini
chown nova:nova /etc/nova/api-paste.ini

sed -e "s,127.0.0.1,$KEYSTONE_HOST_IP,g" -i /etc/nova/api-paste.ini
sed -i 's/#--keystone_ec2_url/--keystone_ec2_url/g' /etc/nova/nova.conf

# Set the AUTH_TOKEN
sed -e "s,999888777666,$AUTH_TOKEN,g" -i /etc/nova/api-paste.ini
sed -e "s,999888777666,$AUTH_TOKEN,g" -i /etc/glance/glance-registry.conf
sed -e "s,999888777666,$AUTH_TOKEN,g" -i /etc/glance/glance-api.conf

service glance-api restart
sleep 2
service glance-registry restart
sleep 2
glance-manage db_sync

# Add user to keystone
./user_add_keystone.sh


echo "export NOVA_AUTH_STRATEGY=\"keystone\"" >> ~/creds/novarc
echo "export OS_AUTH_USER=\$NOVA_USERNAME" >> ~/creds/novarc
echo "export OS_AUTH_KEY=\$NOVA_API_KEY" >> ~/creds/novarc
echo "export OS_AUTH_TENANT=\$NOVA_PROJECT_ID" >> ~/creds/novarc
echo "export OS_AUTH_URL=\$NOVA_URL" >> ~/creds/novarc
echo "export OS_AUTH_STRATEGY=\$NOVA_AUTH_STRATEGY" >> ~/creds/novarc

echo "export NOVA_AUTH_STRATEGY=\"keystone\"" >> ~/.bashrc
echo "export OS_AUTH_USER=\$NOVA_USERNAME" >> ~/.bashrc
echo "export OS_AUTH_KEY=\$NOVA_API_KEY" >> ~/.bashrc
echo "export OS_AUTH_TENANT=\$NOVA_PROJECT_ID" >> ~/.bashrc
echo "export OS_AUTH_URL=\$NOVA_URL" >> ~/.bashrc
echo "export OS_AUTH_STRATEGY=\$NOVA_AUTH_STRATEGY" >> ~/.bashrc

restart libvirt-bin;restart nova-network;restart nova-compute;restart nova-api;restart nova-objectstore
restart nova-scheduler

echo "Please hit <ENTER> to continue"
read DUMMY

exit 0

