#!/sbin/sh

if [ ! -e /system/xbin/busybox ]; then
	mv /tmp/busybox /system/xbin/busybox
fi
