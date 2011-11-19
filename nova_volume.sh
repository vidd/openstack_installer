#! /bin/bash
# Set up Nova Volumes

echo "Set up Nova-Volume"
echo "Add 'nova ALL = (root) NOPASSWD: /bin/dd'"
echo "to the '# Cmnd alias specification'"
echo "of your /etc/sudoers file"
echo "Hit <ENTER> when ready"
read -s DUMMY

NOVA_SUDO=N
until [ "$NOVA_SUDO" = "y" ]; do
	visudo
	echo "If visudo failed, services will not work properly"
	echo "Did visudo succeed? (yes/No)"
	read NOVA_SUDO
done
LVM_SETUP=z
until [ "$LVM_SETUP" = "y" -o "$LVM_SETUP" = "n" ]; do
	echo "Do we need to set up the LVM partion for Nova-Volume?"
	read LVM_SETUP
	case $LVM_SETUP in
		y ) echo "Enter partition for Nova-Volume"
			echo "If unsure enter which drve to pick hit <?>"
			echo "Do not include the /dev/"
			read LVM_drive
				until [ "$LVM_drive" != "?" ]; do 
					fdisk -l
					echo "Enter partition for Nova-Volume"
					echo "If unsure enter which drve to pick hit <?>"
					echo "Do not include the /dev/"
					read LVM_drive
				done 
			pvcreate /dev/$LVM_drive
			vgcreate nova-volumes /dev/$LVM_drive ;;
		n ) echo "OK, Moving on then" ;;
		* ) echo "Please enter y or n" ;;
	esac
done

exit 0
