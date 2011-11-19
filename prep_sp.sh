#! /bin/bash
#./prep_sp.sh

# We were brought here for a reason
# so we remove the "server-path" file
# if it already exists

if [ -f server-path ];then
	rm server-path
fi

touch server-path 

while [ -z $MY_HOST ]; do 
	echo "Enter Host IP"
	read MY_HOST
done

ANSWER=z
until [ "$ANSWER" = "y" -o "$ANSWER" = "n" ]; do
echo "Are all services on the same machine?"
read ANSWER
	case $ANSWER in
	y )
	NOVA_HOST_IP=$MY_HOST
	KEYSTONE_HOST_IP=$MY_HOST
	GLANCE_HOST_IP=$MY_HOST
	RABBIT_HOST_IP=$MY_HOST
	;;
	n )
	echo "Enter your Nova Host IP"
	read NOVA_HOST_IP
		if [-z $NOVA_HOST_IP ]; then NOVA_HOST_IP=$MY_HOST; fi
	echo "Enter your Glance Server IP"
	read GLANCE_HOST_IP
		if [-z $GLANCE_HOST_IP ]; then GLANCE_HOST_IP=$MY_HOST; fi
	echo "Enter your Keystone Server IP"
	read KEYSTONE_HOST_IP
		if [-z $KEYSTONE_HOST_IP ]; then KEYSTONE_HOST_IP=$MY_HOST; fi
	echo "Enter your Rabbit Messanger Server IP"
	read RABBIT_HOST_IP
		if [-z $RABBIT_HOST_IP ]; then RABBIT_HOST_IP=$MY_HOST; fi
	;;
	* ) echo "Please enter y for YES or n for NO" ;;
	esac
done
TESTER=z
until [ -z "$TESTER" ]; do
	echo "1)NOVA HOST is $NOVA_HOST_IP"
	echo "2)RABBIT HOST is $RABBIT_HOST_IP"
	echo "3)GLANCE HOST is $GLANCE_HOST_IP"
	echo "4)KEYSTONE HOST $KEYSTONE_HOST_IP"
	echo "press <ENTER> to continue"
	echo "or the number to correct"
	read TESTER
	case $TESTER in
		1 ) echo "Enter your Nova Host IP"
	        read NOVA_HOST_IP ;;
	        2 ) echo "Enter your Rabbit Messanger Server IP"
	        read RABBIT_HOST_IP ;;
		3 ) echo "Enter your Glance Server IP"
	        read GLANCE_HOST_IP ;;
	        4 ) echo "Enter your Keystone Server IP"
	        read KEYSTONE_HOST_IP ;;
	esac
done


echo "NOVA_HOST_IP=$NOVA_HOST_IP" >> server-path
echo "KEYSTONE_HOST_IP=$KEYSTONE_HOST_IP" >> server-path
echo "GLANCE_HOST_IP=$GLANCE_HOST_IP" >> server-path
echo "RABBIT_HOST_IP=$RABBIT_HOST_IP" >> server-path


echo "This information is in a file called \"server-path\""
echo "You may need to use the information in this file"
echo "if you install services on other servers"
echo ""
echo "Please hit <ENTER> to continue"
echo "or press \"y\" to view the file"
echo "(script will continue upon close)"
read SEE
        if [ "$SEE" = "y" ]; then nano server-path; fi

exit 0



