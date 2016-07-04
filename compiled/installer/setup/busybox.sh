#!/sbin/sh

if [ ! -e /system/xbin/busybox ]; then
	mv /tmp/busybox /system/xbin/busybox
	/system/xbin/busybox --install -s /system/xbin
fi
