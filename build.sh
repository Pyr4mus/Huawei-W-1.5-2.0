#!/bin/bash

REVISION="$(git log --pretty=format:'%h' -n 1)"

CURDATE=`date "+%m-%d-%Y"`
VERSION="-Negalite-HW-$REVISION"

PARENT=`readlink -f .`
INITRAMFS=$PARENT/compiled
INSTALLER=$PARENT/compiled/installer
MKBOOT=$PARENT/mkboot
TOOLCHAIN="Uber" #Choices:[Linaro, SaberMod, Uber]
CONFIG="Nega" #Choices:[Stock, Nega]

chmod 755 $PARENT/scripts/gcc-wrapper.py

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
echo "               Cleaning Up Old Compiled Files                 "
echo "**************************************************************"
echo "**************************************************************"
echo " "

make mrproper
make clean

echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "               Setting Up Configuration Files                 "
echo "**************************************************************"
echo "**************************************************************"
echo " "

## Linaro Toolchain ##
if [ $TOOLCHAIN = "Linaro" ]; then
	export PATH=$PARENT/ccache:$PARENT/toolchains/linaro-4.9.4/bin:$PATH
	export CROSS_COMPILE=arm-cortex_a7-linux-gnueabihf-
fi;

## SaberMod Toolchain ##
if [ $TOOLCHAIN = "SaberMod" ]; then
	export PATH=$PARENT/ccache:$PARENT/toolchains/sabermod-4.9.x/bin:$PATH
	export CROSS_COMPILE=arm-eabi-
fi;

## Uber Toolchain ##
if [ $TOOLCHAIN = "Uber" ]; then
	export PATH=$PARENT/ccache:$PARENT/toolchains/ubertc-4.9.4/bin:$PATH
	export CROSS_COMPILE=arm-eabi-
fi;

export ARCH=arm

if [ $CONFIG = "Stock" ]; then
	make sturgeon_stock_defconfig
else
	make sturgeon_defconfig
fi;

echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "      Modding .config file "$VERSION $CURDATE    
echo "**************************************************************"
echo "**************************************************************"

sed -i 's,CONFIG_LOCALVERSION="negalite-HW",CONFIG_LOCALVERSION="'$VERSION'",' .config

echo "         ______                   _       _                   "
echo "        |  ___ \                 | |     (_)_                 "
echo "        | |   | | ____ ____  ____| |      _| |_  ____         "
echo "        | |   | |/ _  ) _  |/ _  | |     | |  _)/ _  )        "
echo "        | |   | ( (/ ( ( | ( ( | | |_____| | |_( (/ /         "
echo "        |_|   |_|\____)_|| |\_||_|_______)_|\___)____)        "
echo "                     (_____|                                  "
echo " "
echo "                     Negalite HW Kernel                       "
echo "                     Revision: $REVISION                      "
echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "                 !!!!!!Now Compiling!!!!!!                    "
echo "        Log Being Sent To (Kernel Source)/build.log           "
echo "	    Only Errors Will Show Up In Terminal                    "
echo "     This May Take Up To An Hour, Depending On Hardware       "
echo "**************************************************************"
echo "**************************************************************"

# Start Timer
TIME1=$(date +%s)

function progress(){
echo -n "Please wait..."
while true
do
     echo -n "."
     sleep 5
done
}

function compile(){
	
	make -j`grep 'processor' /proc/cpuinfo | wc -l` V=s 2>&1 | tee build.log | grep -e ERROR -e Error

	if [ -e $PARENT/arch/arm/boot/zImage-dtb ]; then
		echo " "
		echo "**************************************************************"
		echo "**************************************************************"
		echo "                   zImage-dtb Compiled!!!                     "
		echo "**************************************************************"
		echo "**************************************************************"
		echo " "
		
		cp $PARENT/arch/arm/boot/zImage-dtb $INITRAMFS/zImage-dtb
		
		echo " "
		echo "**************************************************************"
		echo "**************************************************************"
		echo "                Packing zImage-dtb into boot.img                  "
		echo "**************************************************************"
		echo "**************************************************************"
		echo " "
		
		cd $INITRAMFS
		CMD='androidboot.hardware=sturgeon user_debug=31 maxcpus=4 msm_rtb.filter=0x3F selinux=1 pm_levels.sleep_disabled=1 console=null androidboot.console=null'

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
	
		echo " "
		echo "**************************************************************"
		echo "**************************************************************"
		echo "              Compile finished Successfully!!!                "
		echo " Both 'negalite_kernel_HW_$REVISION.zip(s)' Are Located In The 'compiled' Folder "
		echo "**************************************************************"
		echo "**************************************************************"
		echo " "
	else
		echo " "
		echo "**************************************************************"
		echo "**************************************************************"
		echo "        Something went wrong, zImage did not build...         "
		echo "**************************************************************"
		echo "**************************************************************"
		echo " "
	fi;
}

# Start progress bar in the background
progress &
# Start backup
compile

# End Timer, GetResult
TIME2=$(date +%s)
DIFFSEC="$(expr $TIME2 - $TIME1)"

echo "**************************************************************"
echo "**************************************************************"
echo | awk -v D=$DIFFSEC '{printf "                   Compile time: %02d:%02d:%02d\n",D/(60*60),D%(60*60)/60,D%60}'
echo "**************************************************************"
echo "**************************************************************"
echo " "

# Kill progress
kill $! 1>&1
