#!/bin/bash

REVISION="$(git log --pretty=format:'%h' -n 1)"
PARENT=`readlink -f .`
INITRAMFS=$PARENT/compiled

if [ -e $INITRAMFS/negalite_kernel_HW_$REVISION-2.0.zip ]; then
	echo " "
	echo "**************************************************************"
	echo "**************************************************************"
	echo "      Pushing negalite_kernel_HW_$REVISION-2.0.zip To Watch      "
	echo "**************************************************************"
	echo "**************************************************************"
	echo " "

	adb push $INITRAMFS/negalite_kernel_HW_$REVISION-2.0.zip /sdcard/
	
	# Delete bootperf.zip Option
	echo " "
	echo "**************************************************************"
	echo "**************************************************************"
	read -p "  Would You Like To Delete bootperf.zip From SDCard? <y/n> " prompt_1
	echo "**************************************************************"
	echo "**************************************************************"
	echo " "
	if [[ $prompt_1 == "y" || $prompt_1 == "Y" ]]; then
		adb shell su rm /sdcard/bootperf.zip
	fi	
	
	echo " "
	echo "**************************************************************"
	echo "**************************************************************"
	echo "                Rebooting Watch Into Recovery                 "
	echo "**************************************************************"
	echo "**************************************************************"
	echo " "	
	
	adb reboot recovery
else
	echo " "
	echo "**************************************************************"
	echo "**************************************************************"
	echo "                 You Need To Compile First!!!                 "
	echo "                   !!!Nothing To Push!!!                      "
	echo "**************************************************************"
	echo "**************************************************************"
fi
