#!/bin/bash
#

if [ $# != 1 ]; then
    echo "Usage: `basename $0` seed"
    exit 1
fi

time=3000
seed=$1
domain[0]=2
groups[0]=5
domain[1]=2
groups[1]=10
domain[2]=4
groups[2]=5
domain[3]=10
groups[3]=2

for c in 0 1 2 3 ; do
    for grid_length in 1000 2000 3000 ; do
	for speed in 2 5 10 20 ; do

	    echo run_group.sh -t $time -s $seed -d ${domain[$c]} -G ${groups[$c]} -L $grid_length -S $speed -A adaptive -b

	    echo run_group.sh -t $time -s $seed -d ${domain[$c]} -G ${groups[$c]} -L $grid_length -S $speed -A adaptive
	    
	    #for pgw in 10 50; do
	    #echo run_group.sh -t $time -s $seed -d ${domain[$c]} -G ${groups[$c]} -L $grid_length -S $speed -A dynamic -% $pgw
	    #done
	    
	    for pgw in 0 10 50 100; do
	    echo run_group.sh -t $time -s $seed -d ${domain[$c]} -G ${groups[$c]} -L $grid_length -S $speed -A static -% $pgw
	    done
	done
    done
done
