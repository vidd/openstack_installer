#! /bin/bash

. database
# Install rabbitmq-server
apt-get install -y rabbitmq-server

# Add new rabbit user
rabbitmqctl add_user $RABBIT_USER $RABBIT_PASS
rabbitmqctl set_admin $RABBIT_USER
rabbitmqctl set_permissions $RABBIT_USER  '.*' '.*' '.*'

# Remove default rabbit user
rabbitmqctl delete_user guest

# Restart rabbit
/etc/init.d/rabbitmq-server restart

exit 0


