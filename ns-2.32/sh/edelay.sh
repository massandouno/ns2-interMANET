#!/bin/bash

path="./idrm_setting"
rpath="./results"

#traffic.tcl: src, dst info
#$1 trace file
#$2 number of traffics

nt=$2						#number of traffics

#end to end delay
traffic=0;


while [ "$traffic" -lt $nt ]; do

	pid=0;
	d_ts=0;
	s_ts=0;
	
	while read myline
	do
	
		src=$(echo $myline | awk '{print $8}')
		dst=$(echo $myline | awk '{print $4}')
		at=$(echo $myline | awk '{print $14}')
		pid=$(echo $myline | awk '{print $10}')
		d_ts=$(echo $myline | awk '{print $14}')
		s_ts=$(grep -m 1 "pid: $pid " $rpath/$1_edelay_src_$traffic | awk '{print $14}')
		
		echo "pid: $pid d: $d_ts s: $s_ts"
		
		if [ "$pid" > 0 ]; then
			echo "src: $src dst: $dst pid: $pid d: $d_ts s: $s_ts at $at" | awk '{printf "src: %d dst :%d pid: %d delay: %f at %f\n", $2, $4, $6, $8-$10, $12}' >> tmptraffic_e2e_$traffic
		fi
	
	done < $rpath/$1_edelay_dst_$traffic

	cp tmptraffic_e2e_$traffic $rpath/$1_e2eDelay_$traffic
	
	avg.pl $rpath/$1_e2eDelay_$traffic >> $rpath/$1_avg_e2eDelay

	traffic=$(($traffic+1))
done
	avg.pl $rpath/$1_avg_e2eDelay > $rpath/$1_avg_e2eDelay_all

	rm tmptraffic_*
	
