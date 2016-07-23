#!/sbin/sh

if [ -e /system/etc/perf-boot.sh ]; then 
  rm -f /system/etc/perf-boot.sh 
fi 

if [ -e /system/etc/post-init.sh ]; then 
  rm -f /system/etc/post-init.sh 
fi

if [ ! -e /sdcard/bootperf.zip ]; then
	mv /tmp/bootperf.zip /sdcard/bootperf.zip
	/tmp/busybox unzip /sdcard/bootperf.zip perf-boot.sh post-init.sh -d /system/etc
else
	/tmp/busybox unzip /sdcard/bootperf.zip perf-boot.sh post-init.sh -d /system/etc
fi

if [ ! -e /system/etc/init.d ]; then
	mkdir /system/etc/init.d
fi

if [ ! -e /system/etc/init.d/S01turbozram ]; then 
	mv /tmp/S01turbozram /system/etc/init.d/S01turbozram 
fi 

if [ ! -e /system/bin/tinythermald ]; then 
	mv /tmp/tinythermald /system/bin/tinythermald 
fi
