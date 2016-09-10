#!/sbin/sh

if [ ! -e /data/su.img ]; then
	mv /tmp/su.img /data/su.img
fi

if [ -e /system/app/superuser/Superuser.apk ]; then
	rm -rf /system/app/superuser
fi

if [ ! -e /system/app/Superuser/Superuser.apk ]; then
	mkdir /system/app/Superuser
fi
