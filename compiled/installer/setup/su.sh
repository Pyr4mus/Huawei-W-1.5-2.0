#!/sbin/sh

if [ ! -e /data/su.img ]; then
	mv /tmp/su.img /data/su.img
fi

if [ ! -e /system/app/Superuser/Superuser.apk ]; then
	mkdir /system/app/Superuser
	mv /tmp/Superuser.apk /system/app/Superuser/Superuser.apk
fi
