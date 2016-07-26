#!/system/bin/sh

##################################################
#  ______                   _       _            #
# |  ___ \                 | |     (_)_          #
# | |   | | ____ ____  ____| |      _| |_  ____  #
# | |   | |/ _  ) _  |/ _  | |     | |  _)/ _  ) #
# | |   | ( (/ ( ( | ( ( | | |_____| | |_( (/ /  #
# |_|   |_|\____)_|| |\_||_|_______)_|\___)____) #
#              (_____|                           #
##################################################
#                                                #
#     Any changes made will require a Reboot     #
#      Don't forget to re-set permissions        #
#                                                #
##################################################

#===============================================================

##############################
# User Customizable Settings #
##############################

#===============================================================

KERNEL_CONTROL="On"  #choices [On, off]
FS_CONTROL="On"  #choices [On, off]
VMEM_CONTROL="On"  #choices [On, off]
NET_CONTROL="Off"  #choices [On, off]
SD_MEMORY_CONTROL="On"  #choices [On, off]
MEMORY_CONTROL="On"  #choices [On, off]
DEFRAG_DB_CONTROL="On"  #choices [On, off]
ZIPALIGN_CONTROL="On"  #choices [On, off] 
DISABLE_LOGCAT_CONTROL="Off"  #choices [On, off] (Turning 'On' will disable logcat)

#===============================================================

# Memory Settings ( If MEMORY_CONTROL is set to "On" )
MEM_MINFREE="1024,2048,2560,4096,6144,8192"
MEM_KILL="0,58,117,176,529,1000"
MEM_COST="32"
MEM_DEBUG_LEVEL="0"

#===============================================================

# SD Cache Settings ( If SD_MEMORY_CONTROL is set to "On" )
READ_AHEAD_KB="768"
VIR_READ_AHEAD_KB="256"
MAX_RATIO="100"

#####################################
# End Of User Customizable Settings #
#####################################

mount -o rw,remount,rw /system

# Kernel
if [ $KERNEL_CONTROL = "On" ]; then
	echo "100000" > /proc/sys/kernel/sched_rt_period_us
	echo "95000" > /proc/sys/kernel/sched_rt_runtime_us
	echo "0" > /proc/sys/kernel/sched_child_runs_first
	echo "0" > /proc/sys/kernel/tainted
	echo "5" > /proc/sys/kernel/panic
	echo "0" > /proc/sys/kernel/panic_on_oops
	echo "1333" > /proc/sys/kernel/random/read_wakeup_threshold
	echo "4096" > /proc/sys/kernel/random/write_wakeup_threshold
	echo "524288" > /proc/sys/kernel/threads-max
	echo "268435456" > /proc/sys/kernel/shmmax
	echo "16777216" > /proc/sys/kernel/shmall
	echo "5000000" > /proc/sys/kernel/sched_latency_ns
	echo "1000000" > /proc/sys/kernel/sched_min_granularity_ns
	echo "1000000" > /proc/sys/kernel/sched_wakeup_granularity_ns
fi

# FileSystem
if [ $FS_CONTROL = "On" ]; then
	echo "43800" > /proc/sys/fs/file-max
	echo "16384" > /proc/sys/fs/inotify/max_queued_events
	echo "128" > /proc/sys/fs/inotify/max_user_instances
	echo "8192" > /proc/sys/fs/inotify/max_user_watches
	echo "45" > /proc/sys/fs/lease-break-time
	echo "1048576" > /proc/sys/fs/nr_open
fi

# Virtual Memory
if [ $VMEM_CONTROL = "On" ]; then
	echo "0" > /proc/sys/vm/block_dump
	echo "1" > /proc/sys/vm/oom_dump_tasks
	echo "3" > /proc/sys/vm/drop_caches
	echo "1" > /proc/sys/vm/overcommit_memory
	echo "100" > /proc/sys/vm/overcommit_ratio
	echo "60" > /proc/sys/vm/dirty_ratio
	echo "40" > /proc/sys/vm/dirty_background_ratio
	echo "25" > /proc/sys/vm/vfs_cache_pressure
	echo "0" > /proc/sys/vm/oom_kill_allocating_task
	echo "4096" > /proc/sys/vm/min_free_kbytes
	echo "0" > /proc/sys/vm/panic_on_oom
	echo "3" > /proc/sys/vm/page-cluster
	echo "0" > /proc/sys/vm/laptop_mode
	echo "4" > /proc/sys/vm/min_free_order_shift
	echo "1000" > /proc/sys/vm/dirty_expire_centisecs
	echo "2000" > /proc/sys/vm/dirty_writeback_centisecs
fi

# Net
if [ $NET_CONTROL = "On" ]; then
	echo "1048576" > /proc/sys/net/core/wmem_max
	echo "1048576" > /proc/sys/net/core/rmem_max
	echo "524288" > /proc/sys/net/core/rmem_default
	echo "524288" > /proc/sys/net/core/wmem_default

	echo "0" > /proc/sys/net/ipv4/tcp_ecn
	echo "1" > /proc/sys/net/ipv4/route/flush
	echo "1" > /proc/sys/net/ipv4/tcp_rfc1337
	echo "0" > /proc/sys/net/ipv4/ip_no_pmtu_disc
	echo "1" > /proc/sys/net/ipv4/tcp_sack
	echo "1" > /proc/sys/net/ipv4/tcp_fack
	echo "1" > /proc/sys/net/ipv4/tcp_window_scaling
	echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects
	echo "0" > /proc/sys/net/ipv4/conf/all/secure_redirects
	echo "0" > /proc/sys/net/ipv4/conf/all/accept_source_route
	echo "1" > /proc/sys/net/ipv4/conf/all/rp_filter
	echo "0" > /proc/sys/net/ipv4/conf/default/accept_redirects
	echo "0" > /proc/sys/net/ipv4/conf/default/secure_redirects
	echo "0" > /proc/sys/net/ipv4/conf/default/accept_source_route
	echo "1" > /proc/sys/net/ipv4/conf/default/rp_filter
	echo "cubic" > /proc/sys/net/ipv4/tcp_congestion_control
	echo "2" > /proc/sys/net/ipv4/tcp_synack_retries
	echo "2" > /proc/sys/net/ipv4/tcp_syn_retries
	echo "1024" > /proc/sys/net/ipv4/tcp_max_syn_backlog
	echo "16384" > /proc/sys/net/ipv4/tcp_max_tw_buckets
	echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_all
	echo "1" > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
	echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
	echo "1" > /proc/sys/net/ipv4/tcp_moderate_rcvbuf
	echo "1800" > /proc/sys/net/ipv4/tcp_keepalive_time
	echo "0" > /proc/sys/net/ipv4/ip_forward
	echo "1" > /proc/sys/net/ipv4/tcp_timestamps
	echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse
	echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle
	echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes
	echo "30" > /proc/sys/net/ipv4/tcp_keepalive_intvl
	echo "15" > /proc/sys/net/ipv4/tcp_fin_timeout
	echo "1" > /proc/sys/net/ipv4/tcp_workaround_signed_windows
	echo "1" > /proc/sys/net/ipv4/tcp_low_latency
	echo "0" > /proc/sys/net/ipv4/ip_no_pmtu_disc
	echo "1" > /proc/sys/net/ipv4/tcp_mtu_probing
	echo "2" > /proc/sys/net/ipv4/tcp_frto
	echo "2" > /proc/sys/net/ipv4/tcp_frto_response
fi

# SD Card Tweaks
if [ $SD_MEMORY_CONTROL = "On" ]; then
	echo $READ_AHEAD_KB > /sys/block/mmcblk0/queue/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/block/mmcblk0rpmb/queue/read_ahead_kb

	echo $READ_AHEAD_KB > /sys/devices/virtual/bdi/179:0/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/devices/virtual/bdi/179:32/read_ahead_kb
	echo $MAX_RATIO > /sys/devices/virtual/bdi/179:0/max_ratio
	echo $MAX_RATIO > /sys/devices/virtual/bdi/default/max_ratio

	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:0/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:1/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:2/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:3/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:4/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:5/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:6/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:7/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:8/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:9/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:10/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:11/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:12/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:13/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:14/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:15/read_ahead_kb	
	
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:0/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:1/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:2/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:3/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:4/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:5/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:6/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:7/read_ahead_kb

	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/0:20/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/0:21/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/0:22/read_ahead_kb
	
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/253:0/read_ahead_kb
	
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/default/read_ahead_kb
fi

# Memory Management
if [ $MEMORY_CONTROL = "On" ]; then
	chmod 664 /sys/module/lowmemorykiller/parameters/minfile
	chmod 664 /sys/module/lowmemorykiller/parameters/minfree
	echo $MEM_MINFREE > /sys/module/lowmemorykiller/parameters/minfree
	echo $MEM_COST > /sys/module/lowmemorykiller/parameters/cost
	echo $MEM_DEBUG_LEVEL > /sys/module/lowmemorykiller/parameters/debug_level
	echo $MEM_KILL > /sys/module/lowmemorykiller/parameters/adj

	# Flags blocks as non-rotational and increases cache size
	LOOP=`ls -d /sys/block/loop*`
	RAM=`ls -d /sys/block/ram*`
	MMC=`ls -d /sys/block/mmc*`

	for r in $LOOP $RAM; do
        echo "0" > $r/queue/rotational
		echo "1" > $r/queue/iosched/back_seek_penalty
		echo "1" > $r/queue/iosched/low_latency
		echo "1" > $r/queue/iosched/slice_idle
		echo "4" > $r/queue/iosched/fifo_batch
		echo "1" > $r/queue/iosched/writes_starved
		echo "8" > $r/queue/iosched/quantum
		echo "1" > $r/queue/iosched/rev_penalty
		echo "1" > $r/queue/rq_affinity
		echo "0" > $r/queue/iostats
		echo "2" > $r/queue/iosched/writes_starved		
	done

	for m in $LOOP $MMC; do
		echo "512" > $m/queue/nr_requests
	done
fi

# Disable Logcat
if [ $DISABLE_LOGCAT_CONTROL = "On" ]; then
	if [ -e /dev/log/main ]; then
		busybox rm /dev/log/main
	fi
fi

# Defrag Databases
if [ $DEFRAG_DB_CONTROL = "On" ]; then
	for i in \
	`busybox find /data -iname "*.db"`
	do \
		/system/xbin/sqlite3 $i 'VACUUM;'
		/system/xbin/sqlite3 $i 'REINDEX;'
	done

	if [ -d "/dbdata" ]; then
		for i in \
		`busybox find /dbdata -iname "*.db"` 
		do \
			/system/xbin/sqlite3 $i 'VACUUM;'
			/system/xbin/sqlite3 $i 'REINDEX;'
		done
	fi

	if [ -d "/datadata" ]; then
		for i in \
		`busybox find /datadata -iname "*.db"`
		do \
			/system/xbin/sqlite3 $i 'VACUUM;'
			/system/xbin/sqlite3 $i 'REINDEX;'
		done
	fi

	for i in \
	`busybox find /sdcard -iname "*.db"`
	do \
		/system/xbin/sqlite3 $i 'VACUUM;'
		/system/xbin/sqlite3 $i 'REINDEX;'
	done	
fi

# Zipalign
if [ $ZIPALIGN_CONTROL = "On" ]; then
	for apk in \
	`busybox find /system -iname "*.apk"`
	do \
		zipalign -c 4 $apk
		ZIPCHECK=$?
		if [ $ZIPCHECK -eq 1 ]; then
			echo ZipAligning $(basename $apk)
			zipalign -f 4 $apk /cache/$(basename $apk)
			if [ -e /cache/$(basename $apk) ]; then
				cp -f -p /cache/$(basename $apk) $apk
				rm /cache/$(basename $apk)
			else
				echo ZipAligning $(basename $apk)
			fi
		else
			echo ZipAlign already completed on $apk
		fi
	done	
	
	for apk in \
	`busybox find /data -iname "*.apk"`
	do \
		zipalign -c 4 $apk
		ZIPCHECK=$?
		if [ $ZIPCHECK -eq 1 ]; then
			echo ZipAligning $(basename $apk)
			zipalign -f 4 $apk /cache/$(basename $apk)
			if [ -e /cache/$(basename $apk) ]; then
				cp -f -p /cache/$(basename $apk) $apk
				rm /cache/$(basename $apk)
			else
				echo ZipAligning $(basename $apk) Failed
			fi
		else
			echo ZipAlign already completed on $apk
		fi
	done
fi

mount -o ro,remount,ro /system

echo "Perf-boot finished ..."
