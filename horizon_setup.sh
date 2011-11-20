#! /bin/bash
. database
. server-path
# Install Horizon/dashboard

apt-get install -y libapache2-mod-wsgi
apt-get install -y openstack-dashboard

# Prepare the local_settings
cp temp_local_settings.py local_settings.py

sed -e "s,999888777666,$AUTH_TOKEN,g" -i local_settings.py
sed -e "s,%DASH_DATABASE_NAME%,$DASH_DATABASE_NAME,g" -i local_settings.py
sed -e "s,%DASH_DATABASE_HOST%,$DASH_DATABASE_HOST,g" -i local_settings.py
sed -e "s,%DASH_DATABASE_USER%,$DASH_DATABASE_USER,g" -i local_settings.py
sed -e "s,%DASH_DATABASE_PASS%,$DASH_DATABASE_PASS,g" -i local_settings.py
sed -e "s,%KEYSTONE_HOST_IP%,$KEYSTONE_HOST_IP,g" -i local_settings.py

# Move the local_settings

mv local_settings.py /etc/openstack-dashboard/local_settings.py

# Load the Horizon database
/usr/share/openstack-dashboard/dashboard/manage.py syncdb

# Restart apache

service apache2 restart

exit 0
