#!/bin/sh

if [ -d /sys/block/*/$MDEV ]; then
	mkdir -p /media/$MDEV
	mount -t auto -o sync /dev/$MDEV /media/$MDEV
fi

