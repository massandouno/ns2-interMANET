#!/bin/bash

if [ $# -ne 1 ]; then
    echo "
  Usage : `basename $0` /path/to/dump/file/or/oh/file.

  Input format: time nodeId inter_intra_idrm_out

  Output format: time accumulated_inter_intra_idrm_out
    "
    exit 1
fi

prev_time=0
sum=0
grep "\[IDRM_OVERHEAD\]" $1 | awk '{print $4" "$3" "($37+$40)}' | while read time nodeId idrm
do
	sum=$(($sum + $idrm))
    if [ $time != $prev_time ]; then  ## final value for each timestamp
		echo $time $sum
	fi
	prev_time=$time
done
