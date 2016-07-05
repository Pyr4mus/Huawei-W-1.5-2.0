#!/system/bin/sh

#####################################################################################################
#                                     START CONFIGURABLE SETTINGS                                   #
#####################################################################################################

#SELinux Control
SELINUX="Off"

# CPU Settings ( If CPU_CONTROL is set to "On" )
CPU_MAX="787200" # [300000 384000 600000 787200 998400 1094400 1190400]
CPU_BOOST_MAX="1190400" # [300000 384000 600000 787200 998400 1094400 1190400]
CPU_MIN="300000" # [300000 384000 600000 787200 998400 1094400 1190400]

# CPU Cores Online
CPU_ONLINE="1" #(1=All Cores Enabled)

# CPU Governor
CPU_GOV="userspace" # [intellidemand intelliactive interactiveX thunderx pegasusq smartmax ondemand userspace powersave performance]

# Ondemand Settings(if chosen)
OND_SAMP_RATE="20000"
OND_SAMP_DOWN_FACT="2"
OND_UP_THRESH="45"
OND_IO_BUSY="1"

# GPU Frequency
GPU_FREQ_MAX="200000000" # [200000000 320000000 450000000]
GPU_FREQ_MIN="200000000" # [200000000 320000000 450000000]

# GPU Governor
GPU_GOV="performance" # [cpufreq userspace powersave performance simple_ondemand]

# Vibrator Voltage
VIB_VOLT="130"

# Scheduler
SCHEDULER="cfq" # [noop deadline row cfq vr sio zen fifo fiops]

# Intelli-Plug
INTELLI_PLUG="Off" #choices: [On, Off]
INTELLI_RUN_THRESH="350"
INTELLI_HYSTERESIS="6"
INTELLI_CORES="4"
INTELLI_PROFILE="3" # [0=balanced 1=performance 2=conservative 3=eco-performance 4=eco-conservative]
INTELLI_TOUCH_BOOST="0"

#####################################################################################################
#                                     END CONFIGURABLE SETTINGS                                     #
#####################################################################################################

echo "Running Post-Init Script"

# SELinux Control
if [ $SELINUX = "On" ]; then
	echo "1" > /sys/fs/selinux/enforce
else
	echo "0" > /sys/fs/selinux/enforce
fi

# Intelli-Plug
if [ $INTELLI_PLUG = "On" ]; then
	echo "1" > /sys/module/intelli_plug/parameters/intelli_plug_active
	echo $INTELLI_RUN_THRESH > /sys/module/intelli_plug/parameters/cpu_nr_run_threshold
	echo $INTELLI_HYSTERESIS > /sys/module/intelli_plug/parameters/nr_run_hysteresis
	echo $INTELLI_CORES > /sys/module/intelli_plug/parameters/nr_possible_cores
	echo $INTELLI_PROFILE > /sys/module/intelli_plug/parameters/nr_run_profile_sel
	echo $INTELLI_TOUCH_BOOST > /sys/module/intelli_plug/parameters/touch_boost_active
else	
	echo "0" > /sys/module/intelli_plug/parameters/eco_mode_active
fi

echo $SCHEDULER > /sys/block/stl10/queue/scheduler
echo $SCHEDULER > /sys/block/stl11/queue/scheduler
echo $SCHEDULER > /sys/block/stl9/queue/scheduler
echo $SCHEDULER > /sys/block/mmcblk0/queue/scheduler
echo $SCHEDULER > /sys/block/mmcblk1/queue/scheduler

# Governor Control
echo $CPU_GOV > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo $CPU_GOV > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo $CPU_GOV > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo $CPU_GOV > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor

GOVERNOR=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`

if [ $GOVERNOR = "ondemand" ]; then
	echo $OND_SAMP_RATE > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
	echo $OND_UP_THRESH > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
	echo $OND_IO_BUSY > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
	echo "1" > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
	echo $OND_SAMP_DOWN_FACT > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
fi

# GPU Control
echo $GPU_FREQ_MIN > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
echo $GPU_FREQ_MAX > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
echo $GPU_GOV > /sys/class/kgsl/kgsl-3d0/devfreq/governor

# Vibrator Voltage
echo $VIB_VOLT > /sys/module/drv2605/parameters/vibrator_volt

# CPU Control
if [ $CPU_ONLINE = "1" ]; then
	echo 1 > /sys/devices/system/cpu/cpu1/online
	echo 1 > /sys/devices/system/cpu/cpu2/online
	echo 1 > /sys/devices/system/cpu/cpu3/online
else
	echo 0 > /sys/devices/system/cpu/cpu1/online
	echo 0 > /sys/devices/system/cpu/cpu2/online
	echo 0 > /sys/devices/system/cpu/cpu3/online
fi

# CPU BOOST
echo 100 > /sys/module/cpu_boost/parameters/boost_ms
echo $CPU_BOOST_MAX > /sys/module/cpu_boost/parameters/input_boost_freq
echo 100 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 1 > /sys/module/cpu_boost/parameters/load_based_syncs
echo 15 > /sys/module/cpu_boost/parameters/migration_load_threshold
echo $CPU_MAX > /sys/module/cpu_boost/parameters/sync_threshold

echo $CPU_MIN > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo $CPU_MAX > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

echo "Post-init finished ..."
