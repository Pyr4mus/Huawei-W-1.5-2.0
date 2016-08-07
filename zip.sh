#!/bin/bash

REVISION="$(git log --pretty=format:'%h' -n 1)"

CURDATE=`date "+%m-%d-%Y"`
VERSION="-Negalite-HW-$REVISION"

PARENT=`readlink -f .`
INITRAMFS=$PARENT/compiled
INSTALLER=$PARENT/compiled/installer
MKBOOT=$PARENT/mkboot

echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "                Cleaning Up Old Install Files                 "
echo "**************************************************************"
echo "**************************************************************"
echo " "

if [ -e $INITRAMFS/*-1.5.zip ]; then
	echo "  CLEAN   kernel-1.5.zip"
	rm $INITRAMFS/*-1.5.zip
fi;
if [ -e $INITRAMFS/*-2.0.zip ]; then
	echo "  CLEAN   kernel-2.0.zip"
	rm $INITRAMFS/*-2.0.zip
fi;
if [ -e $INSTALLER/kernel/boot.img ]; then
	echo "  CLEAN   boot.img"
	rm $INSTALLER/kernel/boot.img
fi;
if [ -e $INSTALLER/setup/su.img ]; then
	echo "  CLEAN   su.img"
	rm $INSTALLER/setup/su.img
fi;
if [ -e $INITRAMFS/*-15.gz ]; then
	echo "  CLEAN   ramdisk-15.gz"
	rm $INITRAMFS/*-15.gz
fi;
if [ -e $INITRAMFS/*-20.gz ]; then
	echo "  CLEAN   ramdisk-20.gz"
	rm $INITRAMFS/*-20.gz
fi;
if [ -e $INSTALLER/bootperf.zip ]; then
	echo "  CLEAN   bootperf.zip"
	rm $INSTALLER/bootperf.zip
fi;
		
echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "                Packing zImage-dtb into boot.img              "
echo "**************************************************************"
echo "**************************************************************"
echo " "

cd $INITRAMFS
CMD='androidboot.hardware=sturgeon user_debug=31 maxcpus=4 msm_rtb.filter=0x3F selinux=1 pm_levels.sleep_disabled=1 console=null androidboot.console=null zcache'

echo "  MKBOOT   ramdisk-15"
$MKBOOT/mkbootfs ramdisk-15 | gzip > ramdisk-15.gz
$MKBOOT/mkbootimg --kernel zImage-dtb --ramdisk ramdisk-15.gz --cmdline "$CMD" --base 0x00000000 --pagesize 2048 --ramdisk_offset 0x02000000 -o boot-15.img

echo "  MKBOOT   ramdisk-20"
$MKBOOT/mkbootfs ramdisk-20 | gzip > ramdisk-20.gz
$MKBOOT/mkbootimg --kernel zImage-dtb --ramdisk ramdisk-20.gz --cmdline "$CMD" --base 0x00000000 --pagesize 2048 --ramdisk_offset 0x02000000 -o boot-20.img

echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "         Zipping The Kernel Up For Flashable Package          "
echo "**************************************************************"
echo "**************************************************************"
echo " "

cd $INSTALLER

zip -9 -r bootperf perf-boot.sh post-init.sh

mv $INITRAMFS/boot-15.img kernel/boot.img
cp -f $INITRAMFS/su-15.img setup/su.img	
zip -9 -r negalite_kernel_HW kernel META-INF setup superuser com.grarak.kerneladiutor-1 bootperf.zip
mv negalite_kernel_HW.zip $INITRAMFS/negalite_kernel_HW_$REVISION-1.5.zip

rm kernel/boot.img
rm setup/su.img

mv $INITRAMFS/boot-20.img kernel/boot.img
cp -f $INITRAMFS/su-20.img setup/su.img
zip -9 -r negalite_kernel_HW kernel META-INF setup superuser com.grarak.kerneladiutor-1 bootperf.zip
mv negalite_kernel_HW.zip $INITRAMFS/negalite_kernel_HW_$REVISION-2.0.zip
