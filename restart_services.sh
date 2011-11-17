#! /bin/bash
# Make sure all services restart
# and catch any that crashed


echo "Restarting libvirt"; restart libvirt-bin
echo "Restarting nova-network"; restart nova-network
echo "Restarting nova-compute"; restart nova-compute
echo "Restarting nova-api"; restart nova-api
echo "Restarting nova-objectstore"; restart nova-objectstore
echo "Restarting nova-scheduler"; restart nova-scheduler
echo "Restarting nova-volume"; restart nova-volume
glance-control all restart

echo "Did any fail?
read CATCH
if [ "$CATCH" = "y" ]; then
	echo "Restarting libvirt"
	service libvirt-bin stop;service libvirt-bin start
	echo "Restarting nova-network"
	service nova-network stop;service nova-network start
	echo "Restarting nova-compute"
	service nova-compute stop;service nova-compute start
	echo "Restarting nova-api"
	service nova-api stop;service nova-api start
	echo "Restarting nova-objectstore"
	service nova-objectstore stop;service nova-objectstore start
	echo "Restarting nova-scheduler"
	service nova-scheduler stop;service nova-scheduler start
	echo "Restarting nova-volume"
	service nova-volume stop;service nova-volume start
	glance-control all restart
fi
echo "Press <ENTER> to continue"
read DUMMY

exit 0



