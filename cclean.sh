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
if [ -e $PARENT/arch/arm/boot/compressed/piggy.lz4 ]; then
	echo "  CLEAN   piggy.lz4"
	rm $PARENT/arch/arm/boot/compressed/piggy.lz4
fi
if [ -e $INITRAMFS/zImage-dtb ]; then
	echo "  CLEAN   zImage-dtb"
	rm $INITRAMFS/zImage-dtb
fi
if [ -e $INITRAMFS/*-1.5.zip ]; then
	echo "  CLEAN   kernel-1.5.zip"
	rm $INITRAMFS/*-1.5.zip
fi;
if [ -e $INITRAMFS/*-2.0.zip ]; then
	echo "  CLEAN   kernel-2.0.zip"
	rm $INITRAMFS/*-2.0.zip
fi;
if [ -e $INITRAMFS/installer/kernel/boot.img ]; then
	echo "  CLEAN   boot.img"
	rm $INITRAMFS/installer/kernel/boot.img
fi;
if [ -e $INITRAMFS/installer/setup/su.img ]; then
	echo "  CLEAN   su.img"
	rm $INITRAMFS/installer/setup/su.img
fi;
if [ -e $INITRAMFS/*-15.gz ]; then
	echo "  CLEAN   ramdisk-15.gz"
	rm $INITRAMFS/*-15.gz
fi;
if [ -e $INITRAMFS/*-20.gz ]; then
	echo "  CLEAN   ramdisk-20.gz"
	rm $INITRAMFS/*-20.gz
fi;
if [ -e $INITRAMFS/apq8026-sturgeon.dtb ]; then
	echo "  CLEAN   apq8026-sturgeon.dtb"
	rm $INITRAMFS/apq8026-sturgeon.dtb
fi
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
