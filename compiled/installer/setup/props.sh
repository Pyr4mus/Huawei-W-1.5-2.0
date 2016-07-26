#!/sbin/sh

if grep -Fxq "# GPU Settings" /system/build.prop
then
	busybox echo "BuildProps Already Exist..."
else
	busybox echo "" >> /system/build.prop
	busybox echo "# GPU Settings" >> /system/build.prop
	busybox echo "debug.gr.swapinterval=0" >> /system/build.prop
	busybox echo "debug.enabletr=true" >> /system/build.prop
	busybox echo "debug.sf.hw=1" >> /system/build.prop
	busybox echo "video.accelerate.hw=1" >> /system/build.prop
	busybox echo "debug.egl.hw=1" >> /system/build.prop
	busybox echo "debug.egl.profiler=1" >> /system/build.prop
	busybox echo "persist.sys.use_16bpp_alpha=1" >> /system/build.prop
	busybox echo "persist.sys.use_dithering=1" >> /system/build.prop
	busybox echo "debug.performance.tuning=1" >> /system/build.prop
	busybox echo "debug.composition.type=gpu" >> /system/build.prop
	busybox echo "persist.sys.ui.hw=1" >> /system/build.prop
	busybox echo "com.qc.hardware=1" >> /system/build.prop
	busybox echo "debug.qc.hardware=true" >> /system/build.prop
	busybox echo "ro.config.disable.hw_accel=false" >> /system/build.prop
	busybox echo "hw3d.force=1" >> /system/build.prop
	busybox echo "debug.egl.force_msaa=1" >> /system/build.prop
	busybox echo "persist.sys.use_dithering=1" >> /system/build.prop
fi

if grep -Fxq "#Wifi Scan" /system/build.prop
then
	busybox echo "BuildProps Already Exist..."
else
	busybox echo "" >> /system/build.prop
	busybox echo "#Wifi Scan" >> /system/build.prop
	busybox echo "wifi.supplicant_scan_interval=120" >> /system/build.prop
fi
