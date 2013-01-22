#!/bin/bash

path="./idrm_setting"
rpath="./results"

#traffic.tcl: src, dst info
#$1 trace file

#[IDRM_SH_Update Gen] NodeId: 19 updateType: N updateId: 144 dst: 29 at 5.072001 (from BaseAgent)

grep "IDRM_SH_Update Gen" $1 > tmpupdate_gen
grep "IDRM_SH_Update Rec" $1 > tmpupdate_rec

rm $rpath/udelay

while read myline
do

		up_src=$(echo $myline | awk '{print $4}')
		from=$(echo $myline | awk '{print $10}')
		uid=$(echo $myline | awk '{print $8}')
		s=$(echo $myline | awk '{print $12}')
		
		#echo "uid: $uid at: $at"
		
		grep "updateId: $uid " tmpupdate_rec | awk '{print $12}' > same_uid
		sort -n same_uid > sorted_uid
		#s=$(head -1 sorted_uid)
		e=$(tail -1 sorted_uid)

		c=$(wc sorted_uid | awk '{print $1}')
		
		if [ $c -gt 0 ]; then
			echo "uid: $uid start: $s end: $e" | awk '{printf "uid: %d start: %f end: %f delay: %f\n", $2, $4, $6, $6-$4}' >> $rpath/udelay
		fi

		awk 'match($0,"updateId: $uid") == 0 {print $0}' tmpupdate_rec > tmpupdate_rec2
		mv tmpupdate_rec2 tmpupdate_rec

done < tmpupdate_gen

