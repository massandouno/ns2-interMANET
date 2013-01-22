#!/bin/bash
#

time=1500
for speed in "10:20:30"
do
    ##### adaptive with beacon adaptation #####
    echo run_group.sh -t $time -S $speed -A adaptive -b

    for beacon_interval in 5 10 15 20
    do
        ######## adaptive w/o beacon adaptation ##########
	echo run_group.sh -t $time -S $speed -A adaptive -e $beacon_interval -i $beacon_interval

        ######## static ##########
	for pgw in 10 50 100
	do
	    echo run_group.sh -t $time -S $speed -A static -% $pgw -e $beacon_interval -i $beacon_interval
	done

    done

done
