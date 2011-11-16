#! /bin/bash
# Set up Nova Volumes

echo "Set up Nova-Volume"
echo "Add 'nova ALL = (root) NOPASSWD: /bin/dd'"
echo "to the '# Cmnd alias specification'"
echo "of your /etc/sudoers file"
echo "Hit <ENTER> when ready"
read -s DUMMY

NOVA_SUDO=N
until [ $NOVA_SUDO = y ]; do
	visudo
	echo "If visudo failed, services will not work properly"
	echo "Did visudo succeed? (yes/No)"
	read NOVA_SUDO
done
LVM_SETUP=z
until [ "$LVM_SETUP" = "y" -o "$LVM_SETUP" = "n" ]; do
	echo "Do we need to set up the LVM partion"
	echo "for Nova-Volume? If unsure enter '?'"
	read LVM_SETUP

	case $LVM_SETUP in
		y ) echo "Enter partition for Nova-Volume"
			read LVM_drive
			pvcreate /dev/$LVM_drive
			vgcreate nova-volumes /dev/$LVM_drive ;;
		? ) fdisk -l ;;
		n )  ;;
		* ) echo "Please enter y n or ?" ;;
	esac
done

exit=0


