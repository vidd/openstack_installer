#! /bin/bash
. database
# Keystone Setup

# Install Keystone

apt-get install -y keystone python-mysqldb mysql-client curl

# Prepare Keystone
sed -i 's/verbose = False/verbose = True/g' /etc/keystone/keystone.conf
#sed -i 's/log_file = keystone.log/log_file = \/var\/log\/keystone.log/g' /etc/keystone/keystone.conf
sed -i 's/default_store = sqlite/default_store = mysql/g' /etc/keystone/keystone.conf
sed -i 's/sql_connection = /mysql:\/\/%KEYSTONE_DATABASE_USER%:%KEYSTONE_DATABASE_PASS%@%KEYSTONE_DATABASE_HOST%\/%KEYSTONE_DATABASE_NAME% \n\ #sql_connection = /g' /etc/keystone/keystone.conf
sed -e "s,%KEYSTONE_DATABASE_NAME%,$KEYSTONE_DATABASE_NAME,g" -i /etc/keystone/keystone.conf
sed -e "s,%KEYSTONE_DATABASE_USER%,$KEYSTONE_DATABASE_USER,g" -i /etc/keystone/keystone.conf
sed -e "s,%KEYSTONE_DATABASE_PASS%,$KEYSTONE_DATABASE_PASS,g" -i /etc/keystone/keystone.conf
sed -e "s,%KEYSTONE_DATABASE_HOST%,$KEYSTONE_DATABASE_HOST,g" -i /etc/keystone/keystone.conf

service keystone restart
sleep 5

echo "Please hit <ENTER> to continue"
read DUMMY

exit 0


