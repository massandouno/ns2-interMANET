#!/bin/bash

#traffic.tcl: src, dst info
#$1 trace file
#$2 interval
#$3 number of traffics
#$4 DSDV or AODV w/IDRM

rpath="./results/$4"

echo "$rpath"

interval=$2;
nt=$3						#number of traffics

grep src $rpath/$1_traffic.tcl	| awk '{printf $3 " " $7 "\n"}' > tmptraffic_ll_$1

head -$nt tmptraffic_ll_$1 > ttmptraffic_ll_$1
mv ttmptraffic_ll_$1 tmptraffic_ll_$1

grep startoffset $rpath/$1_traffic.tcl	| awk '{printf $3 "\n"}' > tmptraffic_offset_$1
head -$nt tmptraffic_offset_$1 > ttmptraffic_offset_$1
mv ttmptraffic_offset_$1 tmptraffic_offset_$1

head -500 $rpath/$1 | grep ADDING > tmptraffic_mac_$1

start=0;
end=1000;

traffic=0;
current=0;
current_interval=1;

#rm $rpath/$1_udp.txt
#rm $rpath/$1_sh_tp_*
#rm $rpath/$1_overhead

#bc_n=$(grep CONTROL $1 | tail -1 | awk '{print $12}')
#bc_s=$(grep CONTROL $1 | tail -1 | awk '{print $13}')
#echo " $bc_n $bc_s" | awk '{printf "%d %d %d %d \n", $3, $4}' > $rpath/$1_base_overhead

#grep CONTROL $1 | tail -1 | awk '{print $11 " " $13}' > $rpath/$1_base_overhead


grep "IDRM DSDV CONTROL" $rpath/$1  > $rpath/$1_dsdv_overhead
grep "IDRM AODV CONTROL" $rpath/$1  > $rpath/$1_aodv_overhead

grep "IDRM_SH_Update Gen" $rpath/$1 > $rpath/$1_gen
grep "IDRM_SH_Update Rec" $rpath/$1 > $rpath/$1_rec

												
while read myline
do

  src=$(echo $myline | awk '{printf $1}')
  dst=$(echo $myline | awk '{printf $2}')
  
  echo "$src  $dst"
  grep UDP $rpath/$1 | grep from\ $src | grep "NodeId: $dst\ " > $rpath/$1_edelay_dst_$traffic

	grep UDP $rpath/$1 | grep from\ $src | grep "NodeId: $src\ " > $rpath/$1_edelay_src_$traffic
	
	#mac_src=$(grep "Node $src\ " tmptraffic_mac_$1 | awk '{print $10}')
	#mac_src_sent=$(grep "MAC]" $1 | grep "NodeId: $mac_src\ " | wc | awk '{print $1}')
	
	#dst_recv=$(wc $rpath/$1_edelay_dst_$traffic | awk '{print $1}')
	
	#base_control_n=$(grep CONTROL $1 | tail -1 | awk '{print $12}')
	#base_control_s=$(grep CONTROL $1 | tail -1 | awk '{print $13}')
	
	#echo "$mac_src_sent $dst_recv $base_control_n $base_control_s" | awk '{printf "%d %d %d %d \n", $1*1420, $2*1420, $3, $4}' >> $rpath/$1_overhead
  
  cp $rpath/$1_edelay_dst_$traffic tmptraffic_$traffic_$1
  
  while [ "$start" -le "$end" ]; do
  	
  	current=0;
  	sum=0;
  	while [ "$current" -lt "$interval" ]; do
  		
  		now=$(($start+$current))
			  		
			t=$(grep "at $now\." tmptraffic_$traffic_$1 | wc | awk '{print $1}')
			sum=$(($sum+$t))
			current=$(($current+1))

			#echo "now: $now t: $t sum: $sum"
		
		done
		
		#echo "$sum" | awk '{print '$start' " " $1*1420*8.0/1000000.0}' >> $rpath/$1_sh_tp_$traffic
		echo "$sum $interval" | awk '{print '$start' " " $1*1420*8.0/$2/1000000.0}' >> $rpath/$1_sh_tp_$traffic
		
		start=$(($start+$interval))
		
	done

	cat $rpath/$1_sh_tp_$traffic | awk '{print $1}' > $rpath/$1_sh_tp_interval
	cat $rpath/$1_sh_tp_$traffic | awk '{print $2}' > $rpath/$1_sh_tp_udp_$traffic
	
	
	c_offset=$(head -$(($traffic+1)) tmptraffic_offset_$1 | tail -1)
	t_lines=$(($end/$interval))
	#s_lines=$(($c_offset/$interval))
	
	echo "$c_offset $interval" | awk '{printf "%d %d", $1, $2}'
	s_lines=$(echo "$c_offset $interval" | awk '{printf "%d", $1/$2}')
	
	echo "c_offset: $c_offset t_lines: $t_lines s_lines: $s_lines"
	tail -$(($t_lines-$s_lines)) $rpath/$1_sh_tp_udp_$traffic > tmp_file$1
	./avg.pl tmp_file$1 > tmp$1
	cat tmp$1 >> $rpath/$1_sh_tp_udp_$traffic
	cat tmp$1 >> $rpath/$1_sh_tp_udp_$traffic

	rm tmp$1 tmp_file$1
	
	echo "$(($end+20))" >> $rpath/$1_sh_tp_interval
	echo "$(($end+50))" >> $rpath/$1_sh_tp_interval
	
	
	start=0;
	traffic=$(($traffic+1))
	
done < tmptraffic_ll_$1			#input file


#merge...assume we have 5 traffics...
echo "done"
start=0;
traffic=0;

cp $rpath/$1_sh_tp_interval $rpath/$1_sh_tp_base

while [ "$traffic" -lt "$nt" ]; do
	paste $rpath/$1_sh_tp_base $rpath/$1_sh_tp_udp_$traffic > $rpath/$1_sh_tp_rt
	mv $rpath/$1_sh_tp_rt $rpath/$1_sh_tp_base
	traffic=$(($traffic+1))
done

traffic=0;
start=1;

lc=$(cat $rpath/$1_sh_tp_interval | wc | awk '{print $1}')

while [ "$start" -le "$lc" ]; do

	sum=0;
	while [ "$traffic" -lt "$nt" ]; do
	
		t=$(head -$start $rpath/$1_sh_tp_udp_$traffic | tail -1)
		sum=$(echo "$t $sum" | awk '{printf "%f\n",$1+$2}')
		traffic=$(($traffic+1))
	done
	
	traffic=0;
	echo "$sum" >> $rpath/$1_sh_tp_cum
	start=$(($start+1))
done

#mv $rpath/$1_sh_tp_base $rpath/$1_udp.txt
paste $rpath/$1_sh_tp_base $rpath/$1_sh_tp_cum > $rpath/$1_udp.txt

rm tmptraffic*$1
rm $rpath/$1_sh_tp_*
	
