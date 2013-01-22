#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage : $0 /path/to/conn/file.dat"
    exit 1
fi

start_time=0
prev_time=0
sum_count=0
sum_inter=0
sum_total=0
sum_total_new=0
prev_inter=0
prev_total=0
prev_total_new=0
while read time count d1 d2 inter total totalnew
do
    if [ $prev_time == 0 ]; then
	start_time=$time
    else
	sum_count=$(echo $sum_count $prev_count $time $prev_time | awk '{printf $1+($2 * ($3 - $4))}')
	sum_inter=$(echo $sum_inter $prev_inter $time $prev_time | awk '{printf $1+($2 * ($3 - $4))}')
	sum_total=$(echo $sum_total $prev_total $time $prev_time | awk '{printf $1+($2 * ($3 - $4))}')
	sum_total_new=$(echo $sum_total_new $prev_total_new $time $prev_time | awk '{printf $1+($2 * ($3 - $4))}')
    fi
    prev_count=$count
    prev_inter=$inter
    prev_total=$total
    prev_total_new=$totalnew
    prev_time=$time
done < $1
duration=$(echo $prev_time $start_time | awk '{print $1 - $2}')
echo -n "Average active count: "
echo "$sum_count $duration" | awk '{print $1/$2}'
echo -n "Average inter connectivity: "
echo "$sum_inter $duration" | awk '{print $1/$2}'
echo -n "Average intra connectivity: "
echo "$sum_total $sum_inter $duration" | awk '{print ($1-$2)/$3}'
echo -n "Average total connectivity: "
echo "$sum_total $duration" | awk '{print $1/$2}'
echo -n "Average total connectivity (new): "
echo "$sum_total_new $duration" | awk '{print $1/$2}'
