#! /bin/bash
. database
# Keystone Setup

# Install Keystone
apt-get install -y keystone

# Prepare Keystone
sed -i 's/verbose = False/verbose = True/g' /etc/keystone/keystone.conf
#sed -i 's/log_file = keystone.log/log_file = \/var\/log\/keystone.log/g' /etc/keystone/keystone.conf
sed -i 's/default_store = sqlite/default_store = mysql/g' /etc/keystone/keystone.conf
sed -i 's/sqlite:\/\/\/\/var\/lib\/keystone\/keystone.db/mysql:\/\/%KEYSTONE_DATABASE_USER%:%KEYSTONE_DATABASE_PASS%@%KEYSTONE_DATABASE_HOST%\/%KEYSTONE_DATABASE_NAME%/g' /etc/keystone/keystone.conf
sed -e "s,%KEYSTONE_DATABASE_NAME%,$KEYSTONE_DATABASE_NAME,g" -i /etc/keystone/keystone.conf
sed -e "s,%KEYSTONE_DATABASE_USER%,$KEYSTONE_DATABASE_USER,g" -i /etc/keystone/keystone.conf
sed -e "s,%KEYSTONE_DATABASE_PASS%,$KEYSTONE_DATABASE_PASS,g" -i /etc/keystone/keystone.conf
sed -e "s,%KEYSTONE_DATABASE_HOST%,$KEYSTONE_DATABASE_HOST,g" -i /etc/keystone/keystone.conf

service keystone restart
sleep 5

exit 0



