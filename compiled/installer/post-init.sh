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
CPU_GOV="smartmax" # [intellidemand intelliactive interactiveX thunderx pegasusq smartmax ondemand userspace powersave performance]

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
SCHEDULER="vr" # [noop deadline row cfq vr sio zen fifo fiops]

# MSM_HOTPLUG
MSMH_PLUG="On" #choices: [On, Off]
$MSMH_DEBUG_MASK="1"
$MSMH_MIN_CPUS_ONLINE="1"
$MSMH_MAX_CPUS_ONLINE="2"
$MSMH_CPUS_BOOSTED="4"
$MSMH_HISTORY_SIZE="20"
$MSMH_UPDATE_RATES="30"
$MSMH_DOWN_LOCK_DURATION="20"
$MSMH_BOOST_LOCK_DURATION="1000"
$MSMH_FAST_LANE_LOAD="200"
$MSMH_OFFLINE_LOAD="0"
MSMH_IO_IS_BUSY="1"

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

# MSM_HOTPLUG
if [ $MSMH_PLUG = "On" ]; then
	echo $MSMH_DEBUG_MASK > /sys/module/msm_hotplug/parameters/debug_mask
	echo $MSMH_CPUS_BOOSTED > /sys/module/msm_hotplug/cpus_boosted
	echo $MSMH_DOWN_LOCK_DURATION > /sys/module/msm_hotplug/down_lock_duration
	echo $MSMH_FAST_LANE_LOAD > /sys/module/msm_hotplug/fast_lane_load
	echo $MSMH_HISTORY_SIZE > /sys/module/msm_hotplug/history_size
	echo $MSMH_IO_IS_BUSY > /sys/module/msm_hotplug/io_is_busy
	echo $MSMH_MAX_CPUS_ONLINE > /sys/module/msm_hotplug/max_cpus_online
	echo $MSMH_MIN_CPUS_ONLINE > /sys/module/msm_hotplug/min_cpus_online
	echo $MSMH_OFFLINE_LOAD > /sys/module/msm_hotplug/offline_load
	echo $MSMH_UPDATE_RATES > /sys/module/msm_hotplug/update_rates
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
