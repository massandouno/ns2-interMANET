#!/bin/bash

#traffic.tcl: src, dst info
#$1 trace file
#$2 control interval
#$3 number of nodes

spath="./$2"
mkdir $2/final
rpath="$2/final"

cp ./sh_traffic_$3 $spath/$1_traffic.tcl

echo "s_path: $spath r_path: $rpath"

nt=5						#number of traffics


grep src $spath/$1_traffic.tcl	| awk '{printf $3 " " $7 "\n"}' > $rpath/tmptraffic_ll_$1

head -$nt $rpath/tmptraffic_ll_$1 > $rpath/ttmptraffic_ll_$1
mv $rpath/ttmptraffic_ll_$1 $rpath/tmptraffic_ll_$1

grep startoffset $spath/$1_traffic.tcl	| awk '{printf $3 "\n"}' > $rpath/tmptraffic_offset_$1
head -$nt $rpath/tmptraffic_offset_$1 > $rpath/ttmptraffic_offset_$1
mv $rpath/ttmptraffic_offset_$1 $rpath/tmptraffic_offset_$1

start=0;
end=1000;

traffic=0;
current=0;
current_interval=1;

while read myline
do

  src=$(echo $myline | awk '{printf $1}')
  dst=$(echo $myline | awk '{printf $2}')
  
  echo "$src  $dst"
  grep UDP $spath/$1 | grep from\ $src | grep "NodeId: $dst\ " > $rpath/$1_edelay_dst_$traffic
	grep UDP $spath/$1 | grep from\ $src | grep "NodeId: $src\ " > $rpath/$1_edelay_src_$traffic
  
  #cp $rpath/$1_edelay_dst_$traffic $rpath/tmptraffic_$traffic_$1
	total_packet=$(wc $rpath/$1_edelay_dst_$traffic | awk '{print $1}')
	c_offset=$(head -$(($traffic+1)) $rpath/tmptraffic_offset_$1 | tail -1)

	duration=$(echo "$c_offset $end" | awk '{printf "%f\n", 1/($2-$1)}')
	echo "Duration: $duration total_packet: $total_packet"	

 	udp=$(echo "$total_packet $duration" | awk '{printf "%f\n", $1*1420*8.0*$2/1000000.0}')
	echo "udp $traffic: $udp"

	echo "$udp" >> $rpath/tmptraffic_udp_$1
	#./e2edelay $rpath/$1_edelay_dst_$traffic $rpath/$1_edelay_src_$traffic >> $rpath/tmptraffic_e2e_$1
	
	traffic=$(($traffic+1))
	
done < $rpath/tmptraffic_ll_$1			#input file

./avg.pl $rpath/tmptraffic_udp_$1 > $rpath/$1_udp
./avg.pl $rpath/tmptraffic_e2e_$1 > $rpath/$1_e2e
