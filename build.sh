#!/bin/bash

REVISION="$(git log --pretty=format:'%h' -n 1)"

CURDATE=`date "+%m-%d-%Y"`
VERSION="-Negalite-HW-$REVISION"

PARENT=`readlink -f .`
INITRAMFS=$PARENT/compiled
INSTALLER=$PARENT/compiled/installer
MKBOOT=$PARENT/mkboot

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

echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "               Setting Up Configuration Files                 "
echo "**************************************************************"
echo "**************************************************************"
echo " "

export PATH=$PARENT/ccache:$PARENT/toolchain-4.9.4/bin:$PATH
export CROSS_COMPILE=arm-cortex_a7-linux-gnueabihf-
export ARCH=arm

make sturgeon_defconfig
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
		echo "                Packing zImage into boot.img                  "
		echo "**************************************************************"
		echo "**************************************************************"
		echo " "
		
		cd $INITRAMFS
		CMD='androidboot.hardware=sturgeon user_debug=31 maxcpus=4 msm_rtb.filter=0x3F pm_levels.sleep_disabled=1 console=null androidboot.console=null zcache'

		$MKBOOT/mkbootfs ramdisk | gzip > ramdisk.gz
		$MKBOOT/mkbootimg --kernel zImage-dtb --ramdisk ramdisk.gz --cmdline "$CMD" --base 0x00000000 --pagesize 2048 --ramdisk_offset 0x02000000 -o boot.img
		mv boot.img ./installer/kernel/boot.img
		
		echo " "
		echo "**************************************************************"
		echo "**************************************************************"
		echo "         Zipping The Kernel Up For Flashable Package          "
		echo "**************************************************************"
		echo "**************************************************************"
		echo " "
		
		cd $INSTALLER

		zip -9 -r bootperf perf-boot.sh post-init.sh
		zip -9 -r negalite_kernel_HW kernel META-INF setup com.grarak.kerneladiutor-1 build.prop bootperf.zip
		mv $INSTALLER/negalite_kernel_HW.zip $INITRAMFS/negalite_kernel_HW_$REVISION.zip
		
		echo " "
		echo "**************************************************************"
		echo "**************************************************************"
		echo "              Compile finished Successfully!!!                "
		echo " Package 'negalite_kernel_HW_$REVISION.zip' Is Located In The 'compiled' Folder "
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
