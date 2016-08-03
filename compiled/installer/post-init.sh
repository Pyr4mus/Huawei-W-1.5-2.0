#!/system/bin/sh

#####################################################################################################
#                                     START CONFIGURABLE SETTINGS                                   #
#####################################################################################################

# SELinux Control
SELINUX="Off"

# CPU Settings
CPU_MAX="787200" # [300000 384000 600000 787200 998400 1094400 1190400]
CPU_BOOST_MAX="1190400" # [300000 384000 600000 787200 998400 1094400 1190400]
CPU_MIN="300000" # [300000 384000 600000 787200 998400 1094400 1190400]

# CPU Cores Online
CPU_ONLINE="1" #(1=All Cores Enabled)

# CPU Thermal Control
THERMAL_VDD="0"
THERMAL_CORE="1"

# GPU Frequency
GPU_FREQ_MAX="533000000" # [200000000 320000000 450000000 533000000]
GPU_FREQ_MIN="200000000" # [200000000 320000000 450000000 533000000]

# GPU Governor
GPU_GOV="msm-adreno-tz" # [cpufreq userspace powersave performance simple_ondemand msm-adreno-tz]

# Simple GPU Algorithm
SIMPLE_ACTIVATE="1"
SIMPLE_LAZINESS="3"
SIMPLE_RAMP_THRESH="7000"

# Vibrator Voltage
VIB_VOLT="130" # [Do Not Exceed 150]

# Scheduler
SCHEDULER="cfq" # [noop deadline row cfq vr sio zen fifo fiops]

# MSM_HOTPLUG
MSMH_PLUG="On" #choices: [On, Off]
MSMH_MIN_CPUS_ONLINE="1"
MSMH_MAX_CPUS_ONLINE="2"
MSMH_CPUS_BOOSTED="4"
MSMH_HISTORY_SIZE="20"
MSMH_UPDATE_RATES="30"
MSMH_DOWN_LOCK_DURATION="20"
MSMH_BOOST_LOCK_DURATION="1000"
MSMH_FAST_LANE_LOAD="200"
MSMH_OFFLINE_LOAD="0"

# CPU Governor
CPU_GOV="conservative" # [ conservative darkness intellidemand intelliactive interactiveX thunderx pegasusq smartmax ondemand userspace powersave performance]

# Global Governor Settings
GOV_IGNORE_NICE_LOAD="0"
GOV_IO_IS_BUSY="0"

# Conservative/Ondemand/Intellidemand/PegasusQ Settings(if chosen)
GOV_FREQ_STEP="5"
GOV_SAMP_RATE="30000"
GOV_SAMP_RATE_MIN="10000"
GOV_SAMP_DOWN_FACT="1"
GOV_UP_THRESH="95"
# Conservative Specific Settings
CON_DOWN_THRESH="20"
# Intellidemand Specific Settings
INT_D_SAMP_RATE_MAX="50000"
# PegasusQ Specific Settings
PEGASUS_DOWN_DIFF="5"
PEGASUS_UP_THRESH_AT_MIN_FREQ="40"

# Interactive/Intelliactive Settings(if chosen)
GOV_ABOVE_HISPEED_DELAY="20000"
GOV_BOOST="0"
GOV_BOOSTPULSE_DUR="10000"
GOV_HISPEED_LOAD="99"
GOV_HISPEED_FREQ="787200"
GOV_MIN_SAMP_TIME="80000"
GOV_SAMP_DWN_FACT="0"
GOV_SYNC_FREQ="0"
GOV_TARGET_LOAD="90"
GOV_TIMR_RATE="20000"
GOV_TIMR_SLACK="50000"
GOV_UP_THRESH_ANY_FREQ="0"
GOV_UP_THRESH_ANY_LOAD="0"
# Intelliactive Specific Settings
INT_A_2_PHASE_FREQ="787200,787200,1190400,1190400"

# SmartMax/ThunderX Settings(if chosen)
GOV_DEBUG_MASK="1"
GOV_SUSP_IDEAL_FREQ="300000"
GOV_AWAKE_IDEAL_FREQ="787200"
GOV_MIN_CPU_LOAD="40"
GOV_MAX_CPU_LOAD="70"
GOV_DWN_RATE="60000"
GOV_UP_RATE="30000"
GOV_RAMP_DWN_STEP="200000"
GOV_RAMP_UP_STEP="200000"
# Smartmax Specific Settings
SMARTMAX_BOOST_FREQ="1190400"
SMARTMAX_TOUCH_POKE_FREQ="1190400"		
SMARTMAX_INPUT_BOOST_DUR="90000"
SMARTMAX_MIN_SAMP_RATE="10000"
SMARTMAX_SAMP_RATE="30000"
# ThunderX Specific Settings
THUNDERX_SLEEP_WAKEUP_FREQ="600000"
THUNDERX_SAMP_RATE_JIFFIES="2"

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

# Scheduler
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

# CPU BOOST
echo 1 > /sys/module/cpu_boost/parameters/cpu_boost
echo 100 > /sys/module/cpu_boost/parameters/boost_ms
echo $CPU_BOOST_MAX > /sys/module/cpu_boost/parameters/input_boost_freq
echo 100 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 1 > /sys/module/cpu_boost/parameters/load_based_syncs
echo 15 > /sys/module/cpu_boost/parameters/migration_load_threshold
echo $CPU_MAX > /sys/module/cpu_boost/parameters/sync_threshold

# Thermal Control
echo $THERMAL_CORE > /sys/module/msm_thermal/core_control/enabled
echo $THERMAL_VDD > /sys/module/msm_thermal/vdd_restriction/enabled
echo $CPU_MIN > /sys/module/msm_thermal/vdd_restriction/vdd-apps/value
echo "7" > /sys/module/msm_thermal/vdd_restriction/vdd-dig/value

# MSM_HOTPLUG
if [ $MSMH_PLUG = "On" ]; then
	echo $GOV_DEBUG_MASK > /sys/module/msm_hotplug/parameters/debug_mask
	echo $GOV_IO_IS_BUSY > /sys/module/msm_hotplug/io_is_busy
	echo $MSMH_CPUS_BOOSTED > /sys/module/msm_hotplug/cpus_boosted
	echo $MSMH_DOWN_LOCK_DURATION > /sys/module/msm_hotplug/down_lock_duration
	echo $MSMH_FAST_LANE_LOAD > /sys/module/msm_hotplug/fast_lane_load
	echo $MSMH_HISTORY_SIZE > /sys/module/msm_hotplug/history_size
	echo $MSMH_MAX_CPUS_ONLINE > /sys/module/msm_hotplug/max_cpus_online
	echo $MSMH_MIN_CPUS_ONLINE > /sys/module/msm_hotplug/min_cpus_online
	echo $MSMH_OFFLINE_LOAD > /sys/module/msm_hotplug/offline_load
	echo $MSMH_UPDATE_RATES > /sys/module/msm_hotplug/update_rates
fi

# Governor Control
echo $CPU_GOV > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

SELECTED="/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
GOVERNOR=`cat $SELECTED`

if [ $GOVERNOR = "conservative" ]; then
	echo $GOV_IGNORE_NICE_LOAD > /sys/devices/system/cpu/cpufreq/conservative/ignore_nice_load
	echo $GOV_FREQ_STEP > /sys/devices/system/cpu/cpufreq/conservative/freq_step
	echo $CON_DOWN_THRESH > /sys/devices/system/cpu/cpufreq/conservative/down_threshold
	echo $GOV_SAMP_RATE_MIN > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate_min
	echo $GOV_SAMP_RATE > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
	echo $GOV_UP_THRESH > /sys/devices/system/cpu/cpufreq/conservative/up_threshold
	echo $GOV_SAMP_DOWN_FACT > /sys/devices/system/cpu/cpufreq/conservative/sampling_down_factor
fi

if [ $GOVERNOR = "ondemand" ]; then
	echo $GOV_IO_IS_BUSY > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
	echo $GOV_IGNORE_NICE_LOAD > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
	echo $GOV_SAMP_RATE > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
	echo $GOV_UP_THRESH > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
	echo $GOV_SAMP_DOWN_FACT > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
fi

if [ $GOVERNOR = "intellidemand" ]; then
	echo $GOV_IO_IS_BUSY > /sys/devices/system/cpu/cpufreq/intellidemand/io_is_busy
	echo $GOV_IGNORE_NICE_LOAD > /sys/devices/system/cpu/cpufreq/intellidemand/ignore_nice_load
	echo $GOV_SAMP_RATE_MIN > /sys/devices/system/cpu/cpufreq/intellidemand/sampling_rate_min
	echo $INT_D_SAMP_RATE_MAX > /sys/devices/system/cpu/cpufreq/intellidemand/sampling_rate_max
	echo $GOV_SAMP_RATE > /sys/devices/system/cpu/cpufreq/intellidemand/sampling_rate
	echo $GOV_UP_THRESH > /sys/devices/system/cpu/cpufreq/intellidemand/up_threshold
	echo $GOV_SAMP_DOWN_FACT > /sys/devices/system/cpu/cpufreq/intellidemand/sampling_down_factor
fi

if [ $GOVERNOR = "pegasusq" ]; then
	echo $GOV_IGNORE_NICE_LOAD > /sys/devices/system/cpu/cpufreq/pegasusq/ignore_nice_load
	echo $GOV_IO_IS_BUSY > /sys/devices/system/cpu/cpufreq/pegasusq/io_is_busy
	echo $CPU_MAX > /sys/devices/system/cpu/cpufreq/pegasusq/freq_for_responsiveness
	echo $GOV_FREQ_STEP > /sys/devices/system/cpu/cpufreq/pegasusq/freq_step
	echo $PEGASUS_DOWN_DIFF > /sys/devices/system/cpu/cpufreq/pegasusq/down_differential
	echo $PEGASUS_UP_THRESH_AT_MIN_FREQ > /sys/devices/system/cpu/cpufreq/pegasusq/up_threshold_at_min_freq	
	echo $GOV_SAMP_DOWN_FACT > /sys/devices/system/cpu/cpufreq/pegasusq/sampling_down_factor
	echo $GOV_SAMP_RATE > /sys/devices/system/cpu/cpufreq/pegasusq/sampling_rate
	echo $GOV_SAMP_RATE_MIN > /sys/devices/system/cpu/cpufreq/pegasusq/sampling_rate_min
	echo $GOV_UP_THRESH > /sys/devices/system/cpu/cpufreq/pegasusq/up_threshold
fi

if [ $GOVERNOR = "interactive" ]; then
	echo $GOV_IO_IS_BUSY > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
	echo $GOV_ABOVE_HISPEED_DELAY > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
	echo $GOV_BOOST > /sys/devices/system/cpu/cpufreq/interactive/boost
	echo $GOV_BOOSTPULSE_DUR > /sys/devices/system/cpu/cpufreq/interactive/boostpulse_duration
	echo $GOV_HISPEED_LOAD > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
	echo $GOV_HISPEED_FREQ > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
	echo $GOV_MIN_SAMP_TIME > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
	echo $GOV_SAMP_DWN_FACT > /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor
	echo $GOV_SYNC_FREQ > /sys/devices/system/cpu/cpufreq/interactive/sync_freq
	echo $GOV_TARGET_LOAD > /sys/devices/system/cpu/cpufreq/interactive/target_loads
	echo $GOV_TIMR_RATE > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
	echo $GOV_TIMR_SLACK > /sys/devices/system/cpu/cpufreq/interactive/timer_slack
	echo $GOV_UP_THRESH_ANY_FREQ > /sys/devices/system/cpu/cpufreq/interactive/up_threshold_any_cpu_freq
	echo $GOV_UP_THRESH_ANY_LOAD > /sys/devices/system/cpu/cpufreq/interactive/up_threshold_any_cpu_load
	echo 0 > /sys/module/cpu_boost/parameters/cpu_boost
	echo 1190400 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
fi

if [ $GOVERNOR = "intelliactive" ]; then
	echo $GOV_IO_IS_BUSY > /sys/devices/system/cpu/cpufreq/intelliactive/io_is_busy
	echo $GOV_ABOVE_HISPEED_DELAY > /sys/devices/system/cpu/cpufreq/intelliactive/above_hispeed_delay
	echo $GOV_BOOST > /sys/devices/system/cpu/cpufreq/intelliactive/boost
	echo $GOV_BOOSTPULSE_DUR > /sys/devices/system/cpu/cpufreq/intelliactive/boostpulse_duration
	echo $GOV_HISPEED_LOAD > /sys/devices/system/cpu/cpufreq/intelliactive/go_hispeed_load
	echo $GOV_HISPEED_FREQ > /sys/devices/system/cpu/cpufreq/intelliactive/hispeed_freq
	echo $GOV_MIN_SAMP_TIME > /sys/devices/system/cpu/cpufreq/intelliactive/min_sample_time
	echo $GOV_SAMP_DWN_FACT > /sys/devices/system/cpu/cpufreq/intelliactive/sampling_down_factor
	echo $GOV_SYNC_FREQ > /sys/devices/system/cpu/cpufreq/intelliactive/sync_freq
	echo $GOV_TARGET_LOAD > /sys/devices/system/cpu/cpufreq/intelliactive/target_loads
	echo $GOV_TIMR_RATE > /sys/devices/system/cpu/cpufreq/intelliactive/timer_rate
	echo $GOV_TIMR_SLACK > /sys/devices/system/cpu/cpufreq/intelliactive/timer_slack
	echo $INT_A_2_PHASE_FREQ > /sys/devices/system/cpu/cpufreq/intelliactive/two_phase_freq
	echo $GOV_UP_THRESH_ANY_FREQ > /sys/devices/system/cpu/cpufreq/intelliactive/up_threshold_any_cpu_freq
	echo $GOV_UP_THRESH_ANY_LOAD > /sys/devices/system/cpu/cpufreq/intelliactive/up_threshold_any_cpu_load
	echo 0 > /sys/module/cpu_boost/parameters/cpu_boost
	echo 1190400 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
fi

if [ $GOVERNOR = "smartmax" ]; then
	echo $GOV_DEBUG_MASK > /sys/devices/system/cpu/cpufreq/smartmax/debug_mask	
	echo $GOV_IGNORE_NICE_LOAD > /sys/devices/system/cpu/cpufreq/smartmax/ignore_nice	
	echo $GOV_IO_IS_BUSY > /sys/devices/system/cpu/cpufreq/smartmax/io_is_busy
	echo "1" > /sys/devices/system/cpu/cpufreq/smartmax/ramp_up_during_boost
	echo $GOV_SUSP_IDEAL_FREQ > /sys/devices/system/cpu/cpufreq/smartmax/suspend_ideal_freq	
	echo $GOV_AWAKE_IDEAL_FREQ > /sys/devices/system/cpu/cpufreq/smartmax/awake_ideal_freq	
	echo $SMARTMAX_BOOST_FREQ > /sys/devices/system/cpu/cpufreq/smartmax/boost_freq
	echo $SMARTMAX_TOUCH_POKE_FREQ > /sys/devices/system/cpu/cpufreq/smartmax/touch_poke_freq		
	echo $SMARTMAX_INPUT_BOOST_DUR > /sys/devices/system/cpu/cpufreq/smartmax/input_boost_duration
	echo $SMARTMAX_MIN_SAMP_RATE > /sys/devices/system/cpu/cpufreq/smartmax/min_sampling_rate
	echo $SMARTMAX_SAMP_RATE > /sys/devices/system/cpu/cpufreq/smartmax/sampling_rate	
	echo $GOV_MAX_CPU_LOAD > /sys/devices/system/cpu/cpufreq/smartmax/max_cpu_load
	echo $GOV_MIN_CPU_LOAD > /sys/devices/system/cpu/cpufreq/smartmax/min_cpu_load
	echo $GOV_DWN_RATE > /sys/devices/system/cpu/cpufreq/smartmax/down_rate
	echo $GOV_UP_RATE > /sys/devices/system/cpu/cpufreq/smartmax/up_rate	
	echo $GOV_RAMP_DWN_STEP > /sys/devices/system/cpu/cpufreq/smartmax/ramp_down_step
	echo $GOV_RAMP_UP_STEP > /sys/devices/system/cpu/cpufreq/smartmax/ramp_up_step	
	echo 0 > /sys/module/cpu_boost/parameters/cpu_boost
	echo 1190400 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
fi

if [ $GOVERNOR = "thunderx" ]; then
	echo GOV_DEBUG_MASK > /sys/devices/system/cpu/cpufreq/thunderx/debug_mask
	echo $GOV_SUSP_IDEAL_FREQ > /sys/devices/system/cpu/cpufreq/thunderx/sleep_ideal_freq
	echo $GOV_AWAKE_IDEAL_FREQ > /sys/devices/system/cpu/cpufreq/thunderx/awake_ideal_freq
	echo $THUNDERX_SLEEP_WAKEUP_FREQ > /sys/devices/system/cpu/cpufreq/thunderx/sleep_wakeup_freq
	echo $THUNDERX_SAMP_RATE_JIFFIES > /sys/devices/system/cpu/cpufreq/thunderx/sample_rate_jiffies
	echo $GOV_DWN_RATE > /sys/devices/system/cpu/cpufreq/thunderx/down_rate_us
	echo $GOV_UP_RATE > /sys/devices/system/cpu/cpufreq/thunderx/up_rate_us
	echo $GOV_MAX_CPU_LOAD > /sys/devices/system/cpu/cpufreq/thunderx/max_cpu_load
	echo $GOV_MIN_CPU_LOAD > /sys/devices/system/cpu/cpufreq/thunderx/min_cpu_load
	echo $GOV_RAMP_DWN_STEP > /sys/devices/system/cpu/cpufreq/thunderx/ramp_down_step
	echo $GOV_RAMP_UP_STEP > /sys/devices/system/cpu/cpufreq/thunderx/ramp_up_step
	echo 0 > /sys/module/cpu_boost/parameters/cpu_boost
	echo 1190400 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq	
fi

echo "Post-init finished ..."
