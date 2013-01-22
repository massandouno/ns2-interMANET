#!/bin/bash

#traffic.tcl: src, dst info
#$1 trace file
#$2 interval
#$3 number of traffics
#$4 DSDV or AODV w/IDRM


cat $1 | awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7}' > $1_tmp
sort -k 3 -n $1_tmp | uniq > $1_tmp2
												
while read myline
do

	time=$(echo $myline | awk '{printf $3}')
  src=$(echo $myline | awk '{printf $5}')
  dst=$(echo $myline | awk '{printf $7}')
  
  grep "time= $time " $1 | grep "src= $src " | grep "dst= $dst " > tmptraffics
  cat tmptraffics | awk '{print $9}' > tmptrafficssize
  
  size=$(awk -f sum.awk < tmptrafficssize)
  
  size2=$(echo "$size" | awk '{printf "%d\n", $1*8/1000}')
  
  #<data time= 12 src= 5  dst= 6 bytes= 1420 />
  #<data time="12" src="5" dst="6" bytes="1420" />
	
	echo "<data time=\"$time\" src=\"$src\" dst=\"$dst\" bytes=\"$size2\" />"
	
	#rm tmptraffics*	
done < $1_tmp2			#input file
