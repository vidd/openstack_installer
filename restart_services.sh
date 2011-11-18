#! /bin/bash
# Make sure all services restart
# and catch any that crashed


echo "Restarting libvirt"; restart libvirt-bin
sleep 2
echo "Restarting nova-network"; restart nova-network
sleep 2
echo "Restarting nova-compute"; restart nova-compute
sleep 2
echo "Restarting nova-api"; restart nova-api
sleep 2
echo "Restarting nova-objectstore"; restart nova-objectstore
sleep 2
echo "Restarting nova-scheduler"; restart nova-scheduler
sleep 2
echo "Restarting nova-volume"; restart nova-volume
sleep 2
glance-control all restart
sleep 2
echo "Did any fail?"
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




