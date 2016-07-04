#!/sbin/sh

rm -f /system/build.prop

if [ -e /sdcard/TWRP/build.prop ]; then
	cp -f /sdcard/TWRP/build.prop /system/build.prop
else	
	mv /tmp/build.prop /system/build.prop
fi
