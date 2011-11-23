#! /bin/bash

#set up Glance

echo "installing Glance"
apt-get install -y glance python-httplib2 python-mysqldb
. database
sed -i 's/sql_connection = /sql_connection = mysql:\/\/%GLANCE_DATABASE_USER%:%GLANCE_DATABASE_PASS%@%GLANCE_DATABASE_HOST%\/%GLANCE_DATABASE_NAME% \n\ #sql_connection = /g' /etc/glance/glance-registry.conf
sed -e "s,%GLANCE_DATABASE_NAME%,$GLANCE_DATABASE_NAME,g" -i /etc/glance/glance-registry.conf
sed -e "s,%GLANCE_DATABASE_USER%,$GLANCE_DATABASE_USER,g" -i /etc/glance/glance-registry.conf
sed -e "s,%GLANCE_DATABASE_PASS%,$GLANCE_DATABASE_PASS,g" -i /etc/glance/glance-registry.conf
sed -e "s,%GLANCE_DATABASE_HOST%,$GLANCE_DATABASE_HOST,g" -i /etc/glance/glance-registry.conf

sed -i 's/sql_connection = /mysql:\/\/%GLANCE_DATABASE_USER%:%GLANCE_DATABASE_PASS%@%GLANCE_DATABASE_HOST%\/%GLANCE_DATABASE_NAME% \n\ #sql_connection = /g' /etc/glance/glance-scrubber.conf
sed -e "s,%GLANCE_DATABASE_NAME%,$GLANCE_DATABASE_NAME,g" -i /etc/glance/glance-scrubber.conf
sed -e "s,%GLANCE_DATABASE_USER%,$GLANCE_DATABASE_USER,g" -i /etc/glance/glance-scrubber.conf
sed -e "s,%GLANCE_DATABASE_PASS%,$GLANCE_DATABASE_PASS,g" -i /etc/glance/glance-scrubber.conf
sed -e "s,%GLANCE_DATABASE_HOST%,$GLANCE_DATABASE_HOST,g" -i /etc/glance/glance-scrubber.conf

glance-manage db_sync
sleep 2

glance-control all restart

exit 0

