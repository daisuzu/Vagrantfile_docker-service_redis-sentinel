#!/bin/sh
set -e

MASTER_IP=$MASTER_IP
: ${MASTER_IP:="127.0.0.1"}

sed -i -e "s/127.0.0.1/$MASTER_IP/" /etc/sentinel.conf

redis-server /etc/sentinel.conf --sentinel --protected-mode no
