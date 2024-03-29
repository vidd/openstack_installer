#!/bin/bash
# Set up the databases

if [ ! -f database ]; then
	./prep_db.sh
fi

. database

echo -n "Enter MySQL root password > "
read -s PASS

echo "Building databases"

mysql -uroot -p$PASS -e "CREATE DATABASE $GLANCE_DATABASE_NAME;"
mysql -uroot -p$PASS -e "CREATE USER $GLANCE_DATABASE_USER@'%';"
mysql -uroot -p$PASS -e "GRANT ALL PRIVILEGES ON $GLANCE_DATABASE_NAME.* TO $GLANCE_DATABASE_USER@'%' WITH GRANT OPTION;"
mysql -uroot -p$PASS -e "SET PASSWORD FOR $GLANCE_DATABASE_USER@'%' = PASSWORD('$GLANCE_DATABASE_PASS');"

mysql -uroot -p$PASS -e "CREATE DATABASE $NOVA_DATABASE_NAME;"
mysql -uroot -p$PASS -e "CREATE USER $NOVA_DATABASE_USER@'%';"
mysql -uroot -p$PASS -e "GRANT ALL PRIVILEGES ON $NOVA_DATABASE_NAME.* TO $NOVA_DATABASE_USER@'%' WITH GRANT OPTION;"
mysql -uroot -p$PASS -e "SET PASSWORD FOR $NOVA_DATABASE_USER@'%' = PASSWORD('$NOVA_DATABASE_PASS');"

mysql -uroot -p$PASS -e "CREATE DATABASE $KEYSTONE_DATABASE_NAME;"
mysql -uroot -p$PASS -e "CREATE USER $KEYSTONE_DATABASE_USER@'%';"
mysql -uroot -p$PASS -e "GRANT ALL PRIVILEGES ON $KEYSTONE_DATABASE_NAME.* TO $KEYSTONE_DATABASE_USER@'%' WITH GRANT OPTION;"
mysql -uroot -p$PASS -e "SET PASSWORD FOR $KEYSTONE_DATABASE_USER@'%' = PASSWORD('$KEYSTONE_DATABASE_PASS');"

mysql -uroot -p$PASS -e "CREATE DATABASE $DASH_DATABASE_NAME;"
mysql -uroot -p$PASS -e "CREATE USER $DASH_DATABASE_USER@'%';"
mysql -uroot -p$PASS -e "GRANT ALL PRIVILEGES ON $DASH_DATABASE_NAME.* TO $DASH_DATABASE_USER@'%' WITH GRANT OPTION;"
mysql -uroot -p$PASS -e "SET PASSWORD FOR $DASH_DATABASE_USER@'%' = PASSWORD('$DASH_DATABASE_PASS');"

service mysql restart

echo "Databases configured and ready"

exit 0



