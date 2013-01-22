#!/bin/bash

path="./idrm_setting"
rpath="./results"

#traffic.tcl: src, dst info
#$1 trace file

grep src $path/traffic.tcl	| awk '{printf $3 " " $7 "\n"}' > ll

interval=1;
start=0;
end=500;

traffic=0;

rm $rpath/udp.txt
rm $rpath/sh_tp_*

while read myline
do

  src=$(echo $myline | awk '{printf $1}')
  dst=$(echo $myline | awk '{printf $2}')
  
  echo "$src  $dst"
  grep UDP $1 | grep from\ $src | grep "Id: $dst" > tmptraffic_$traffic
  
  #grep SH_TRF $1 | grep from:\ $src\  | grep NodeId:\ $dst\ >> tmptraffic_$traffic
  
  grep UDP $1 | grep from\ $src | grep "Id: $src" > $rpath/sh_tp_src_$traffic
  
  cp tmptraffic_$traffic $rpath/sh_tp_dst_$traffic
  
  while [ "$start" -le "$end" ]; do
  	grep "at $start\." tmptraffic_$traffic | wc | awk '{print $1}' | awk '{print '$start' " " $1*1420*8.0/1000000.0}' >> $rpath/sh_tp_$traffic
		
		start=$(($start+$interval))
		
	done
	
	#rm tmptraffic_*

	start=0;
	traffic=$(($traffic+1))
	
done < ll			#input file


#merge...assume we have 5 traffics...

start=0;

while [ "$start" -le "$end" ]; do

	t0=$(head -$start $rpath/sh_tp_0 | tail -1 | awk '{print $2}')
	t1=$(head -$start $rpath/sh_tp_1 | tail -1 | awk '{print $2}')
#	t2=$(head -$start $rpath/sh_tp_2 | tail -1 | awk '{print $2}')
#	t3=$(head -$start $rpath/sh_tp_3 | tail -1 | awk '{print $2}')
#	t4=$(head -$start $rpath/sh_tp_4 | tail -1 | awk '{print $2}')

	echo "$start $t0 $t1 $t2 $t3 $t4 $t5" >> $rpath/udp.txt
	start=$(($start+$interval))
	
done


#end to end delay
traffic=0;

while [ "$traffic" -le 4 ]; do

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
		s_ts=$(grep "pid: $pid " $rpath/sh_tp_src_$traffic | awk '{print $14}')
		
		echo "pid: $pid d: $d_ts s: $s_ts"
		
		if [ "$pid" > 0 ]; then
			echo "src: $src dst: $dst pid: $pid d: $d_ts s: $s_ts at $at" | awk '{printf "src: %d dst :%d pid: %d delay: %f at %f\n", $2, $4, $6, $8-$10, $12}' >> tmptraffic_e2e_$traffic
		fi
	
	done < $rpath/sh_tp_dst_$traffic

	cp tmptraffic_e2e_$traffic $rpath/e2eDelay_$traffic		

	traffic=$(($traffic+1))
done

	rm tmptraffic_*
	

