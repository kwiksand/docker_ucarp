#! /bin/sh

UCARP_VIP_ADDRESS=${UCARP_VIP_ADDRESS}
UCARP_HOST_DEVICE=${UCARP_HOST_DEVICE}

if [ -z "$UCARP_VIP_ADDRESS" ]; then
	echo "No UCARP_VIP_ADDRESS provided";
	exit 255;
fi;

if [ -z "$UCARP_HOST_DEVICE" ]; then
        echo "No UCARP_HOST_DEVICE provided";
        exit 255;
fi;

/sbin/ip addr del $UCARP_VIP_ADDRESS dev $UCARP_HOST_DEVICE;
