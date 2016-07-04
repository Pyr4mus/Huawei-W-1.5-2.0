#!/bin/sh

export PARENT=`readlink -f .`
export INITRAMFS=$PARENT/compiled
export INSTALLER=$PARENT/compiled/installer

echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "                Cleaning Up Old Install Files                 "
echo "**************************************************************"
echo "**************************************************************"
echo " "

if [ -e $PARENT/build.log ]; then
	echo "  CLEAN   build.log"
	rm $PARENT/build.log
fi
if [ -e $INITRAMFS/zImage-dtb ]; then
	echo "  CLEAN   zImage-dtb"
	rm $INITRAMFS/zImage-dtb
fi
if [ -e $INITRAMFS/*.zip ]; then
	echo "  CLEAN   kernel.zip"
	rm $INITRAMFS/*.zip
fi;
if [ -e $INITRAMFS/installer/kernel/boot.img ]; then
	echo "  CLEAN   boot.img"
	rm $INITRAMFS/installer/kernel/boot.img
fi;
if [ -e $INITRAMFS/ramdisk.gz ]; then
	echo "  CLEAN   ramdisk.gz"
	rm $INITRAMFS/ramdisk.gz
fi;
if [ -e $INITRAMFS/installer/bootperf.zip ]; then
	echo "  CLEAN   bootperf.zip"
	rm $INITRAMFS/installer/bootperf.zip
fi;

echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "               Cleaning Up Old Compiled Files                 "
echo "**************************************************************"
echo "**************************************************************"
echo " "
make mrproper
make clean
