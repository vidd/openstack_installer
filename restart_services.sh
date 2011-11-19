#! /bin/bash
# Make sure all services restart
# and catch any that crashed

CATCH=y
while [ "$CATCH" = "y" ]; do
	echo "Restarting libvirt"
	service libvirt-bin stop;service libvirt-bin start; restart libvirt-bin
	sleep 2
	echo "Restarting nova-network"
	service nova-network stop;service nova-network start; restart nova-network
        sleep 2
	echo "Restarting nova-compute"
	service nova-compute stop;service nova-compute start; restart nova-compute
        sleep 2
	echo "Restarting nova-api"
	service nova-api stop;service nova-api start; restart nova-api
        sleep 2
	echo "Restarting nova-objectstore"
	service nova-objectstore stop;service nova-objectstore start; restart nova-objectstore
        sleep 2
	echo "Restarting nova-scheduler"
	service nova-scheduler stop;service nova-scheduler start; restart nova-scheduler
        sleep 2
	echo "Restarting nova-volume"
	service nova-volume stop;service nova-volume start; restart nova-volume
        sleep 2
	glance-control all restart
	echo "Did any fail?"
	read CATCH
done
echo "Press <ENTER> to continue"
read DUMMY

exit 0




