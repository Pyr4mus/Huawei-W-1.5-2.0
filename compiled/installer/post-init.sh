#!/system/bin/sh

#####################################################################################################
#                                     START CONFIGURABLE SETTINGS                                   #
#####################################################################################################

#SELinux Control
SELINUX="Off"

# CPU Settings
CPU_MAX="787200" # [300000 384000 600000 787200 998400 1094400 1190400]
CPU_BOOST_MAX="1190400" # [300000 384000 600000 787200 998400 1094400 1190400]
CPU_MIN="300000" # [300000 384000 600000 787200 998400 1094400 1190400]

# CPU Cores Online
CPU_ONLINE="1" #(1=All Cores Enabled)

# CPU Governor
CPU_GOV="intelliactive" # [darkness intellidemand intelliactive interactiveX thunderx pegasusq smartmax ondemand userspace powersave performance]

# CPU Thermal Control
THERMAL_VDD="0"
THERMAL_CORE="1"

# Ondemand Settings(if chosen)
OND_SAMP_RATE="30000"
OND_SAMP_RATE_MIN="10000"
OND_SAMP_RATE_MAX="50000"
OND_SAMP_DOWN_FACT="2"
OND_UP_THRESH="75"
OND_IO_BUSY="1"

# Intelliactive Settings(if chosen)
INTELLI_ABOVE_HISPEED_DELAY="10000"
INTELLI_BOOST="1"
INTELLI_BOOSTPULSE_DUR="10000"
INTELLI_HISPEED_LOAD="35"
INTELLI_HISPEED_FREQ="300000"
INTELLI_MIN_SAMP_TIME="20000"
INTELLI_SAMP_DWN_FACT="1"
INTELLI_SYNC_FREQ="787200"
INTELLI_TARGET_LOAD="80"
INTELLI_TIMR_RATE="20000"
INTELLI_TIMR_SLACK="80000"
INTELLI_2_PHASE_FREQ="600000,787200,1094400,1190400"
INTELLI_UP_THRESH_ANY_FREQ="787200"
INTELLI_UP_THRESH_ANY_LOAD="85"

# GPU Frequency
GPU_FREQ_MAX="533000000" # [200000000 320000000 450000000 533000000]
GPU_FREQ_MIN="200000000" # [200000000 320000000 450000000 533000000]

# GPU Governor
GPU_GOV="msm-adreno-tz" # [cpufreq userspace powersave performance simple_ondemand msm-adreno-tz]

# Simple GPU Algorithm
SIMPLE_ACTIVATE="1"
SIMPLE_LAZINESS="3"
SIMPLE_RAMP_THRESH="6000"

# Vibrator Voltage
VIB_VOLT="130" # [Do Not Exceed 150]

# Scheduler
SCHEDULER="vr" # [noop deadline row cfq vr sio zen fifo fiops]

# MSM_HOTPLUG
MSMH_PLUG="On" #choices: [On, Off]
MSMH_DEBUG_MASK="1"
MSMH_MIN_CPUS_ONLINE="1"
MSMH_MAX_CPUS_ONLINE="2"
MSMH_CPUS_BOOSTED="4"
MSMH_HISTORY_SIZE="20"
MSMH_UPDATE_RATES="30"
MSMH_DOWN_LOCK_DURATION="20"
MSMH_BOOST_LOCK_DURATION="1000"
MSMH_FAST_LANE_LOAD="200"
MSMH_OFFLINE_LOAD="0"
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

# GPU Control
echo $GPU_FREQ_MIN > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
echo $GPU_FREQ_MAX > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
echo $GPU_GOV > /sys/class/kgsl/kgsl-3d0/devfreq/governor

# Simple GPU Algorithm
echo $SIMPLE_ACTIVATE > /sys/module/simple_gpu_algorithm/parameters/simple_gpu_activate
echo $SIMPLE_LAZINESS > /sys/module/simple_gpu_algorithm/parameters/simple_laziness
echo $SIMPLE_RAMP_THRESH > /sys/module/simple_gpu_algorithm/parameters/simple_ramp_threshold

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

echo $CPU_MIN > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo $CPU_MAX > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

# Governor Control
echo $CPU_GOV > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

GOVERNOR=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`

if [ $GOVERNOR = "ondemand" ]; then
	echo $OND_SAMP_RATE > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
	echo $OND_UP_THRESH > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
	echo $OND_IO_BUSY > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
	echo "1" > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
	echo $OND_SAMP_DOWN_FACT > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
fi

if [ $GOVERNOR = "intellidemand" ]; then
	echo $OND_SAMP_RATE_MIN > /sys/devices/system/cpu/cpufreq/intellidemand/sampling_rate_min
	echo $OND_SAMP_RATE_MAX > /sys/devices/system/cpu/cpufreq/intellidemand/sampling_rate_max
	echo $OND_SAMP_RATE > /sys/devices/system/cpu/cpufreq/intellidemand/sampling_rate
	echo $OND_UP_THRESH > /sys/devices/system/cpu/cpufreq/intellidemand/up_threshold
	echo $OND_IO_BUSY > /sys/devices/system/cpu/cpufreq/intellidemand/io_is_busy
	echo "1" > /sys/devices/system/cpu/cpufreq/intellidemand/ignore_nice_load
	echo $OND_SAMP_DOWN_FACT > /sys/devices/system/cpu/cpufreq/intellidemand/sampling_down_factor
fi

if [ $GOVERNOR = "intelliactive" ]; then
	echo $INTELLI_ABOVE_HISPEED_DELAY > /sys/devices/system/cpu/cpufreq/intelliactive/above_hispeed_delay
	echo $INTELLI_BOOST > /sys/devices/system/cpu/cpufreq/intelliactive/boost
	echo $INTELLI_BOOSTPULSE_DUR > /sys/devices/system/cpu/cpufreq/intelliactive/boostpulse_duration
	echo $INTELLI_HISPEED_LOAD > /sys/devices/system/cpu/cpufreq/intelliactive/go_hispeed_load
	echo $INTELLI_HISPEED_FREQ > /sys/devices/system/cpu/cpufreq/intelliactive/hispeed_freq
	echo $OND_IO_BUSY > /sys/devices/system/cpu/cpufreq/intelliactive/io_is_busy
	echo $INTELLI_MIN_SAMP_TIME > /sys/devices/system/cpu/cpufreq/intelliactive/min_sample_time
	echo $INTELLI_SAMP_DWN_FACT > /sys/devices/system/cpu/cpufreq/intelliactive/sampling_down_factor
	echo $INTELLI_SYNC_FREQ > /sys/devices/system/cpu/cpufreq/intelliactive/sync_freq
	echo $INTELLI_TARGET_LOAD > /sys/devices/system/cpu/cpufreq/intelliactive/target_loads
	echo $INTELLI_TIMR_RATE > /sys/devices/system/cpu/cpufreq/intelliactive/timer_rate
	echo $INTELLI_TIMR_SLACK > /sys/devices/system/cpu/cpufreq/intelliactive/timer_slack
	echo $INTELLI_2_PHASE_FREQ > /sys/devices/system/cpu/cpufreq/intelliactive/two_phase_freq
	echo $INTELLI_UP_THRESH_ANY_FREQ > /sys/devices/system/cpu/cpufreq/intelliactive/up_threshold_any_cpu_freq
	echo $INTELLI_UP_THRESH_ANY_LOAD > /sys/devices/system/cpu/cpufreq/intelliactive/up_threshold_any_cpu_load
fi

# Thermal Control
echo $THERMAL_CORE > /sys/module/msm_thermal/core_control/enabled
echo $THERMAL_VDD > /sys/module/msm_thermal/vdd_restriction/enabled
echo $CPU_MIN > /sys/module/msm_thermal/vdd_restriction/vdd-apps/value
echo 7 > /sys/module/msm_thermal/vdd_restriction/vdd-dig/value

INTELLI_BOOST=`cat /sys/devices/system/cpu/cpufreq/intelliactive/boost`

# CPU BOOST
if [ $INTELLI_BOOST = "1" ]; then
	echo 0 > /sys/module/cpu_boost/parameters/cpu_boost
else
	echo 1 > /sys/module/cpu_boost/parameters/cpu_boost
fi
echo 100 > /sys/module/cpu_boost/parameters/boost_ms
echo $CPU_BOOST_MAX > /sys/module/cpu_boost/parameters/input_boost_freq
echo 100 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 1 > /sys/module/cpu_boost/parameters/load_based_syncs
echo 15 > /sys/module/cpu_boost/parameters/migration_load_threshold
echo $CPU_MAX > /sys/module/cpu_boost/parameters/sync_threshold

echo "Post-init finished ..."
