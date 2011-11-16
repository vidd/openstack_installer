#! /bin/bash
# Install the basics

# Create the nova-settings file
touch nova-settings

# Add the PPA
echo "Adding the PPA"
apt-get install -y python-software-properties
apt-add-repository -y ppa:managedit/openstack
apt-get update
apt-get install -y managedit-openstack-pin
apt-get -y dist-upgrade

echo "Preparing basic setup"
apt-get install -y bridge-utils curl euca2ools git iputils-ping locate lsof mysql-server ntp openssh-server pep8 \
phpmyadmin psmisc pylint python-greenlet python-httplib2 python-lxml python-mysqldb python-paste python-pastedeploy \
python-pastescript python-pastewebkit python-pip python-setuptools python-unittest2 python-virtualenv screen tcpdump \
unzip vim-nox wget

echo "Finished installing basic setup"

# Set up NTP and MySQL
echo "Configuring Time Server and MySQL"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
sed -i 's/server ntp.ubuntu.com/server ntp.ubuntu.com n\server 127.127.1.0 n\fudge 127.127.1.0 stratum 10/g' /etc/ntp.conf
service mysql restart
service ntp restart
echo "Time Server and MySQL ready"

exit 0

