#!/bin/bash
#

time=2500
#seed=1
seed=2
domain[0]=2
groups[0]=5
domain[1]=2
groups[1]=10
domain[2]=5
groups[2]=2
domain[3]=5
groups[3]=4

#for c in 0 1 2 3 ; do
for c in 0 ; do
    #for grid_length in 2000 3000 4000 ; do
    for grid_length in 2000 ; do
	for speed in 5 10 20 ; do

	    echo run_group.sh -t $time -s $seed -d ${domain[$c]} -G ${groups[$c]} -L $grid_length -S $speed -A adaptive -b

	    # echo run_group.sh -t $time -s $seed -d ${domain[$c]} -G ${groups[$c]} -L $grid_length -S $speed -A adaptive
	    
	    #for pgw in 10 50; do
	    #echo run_group.sh -t $time -s $seed -d ${domain[$c]} -G ${groups[$c]} -L $grid_length -S $speed -A dynamic -% $pgw
	    #done
	    
	    for pgw in 0 10 50 100; do
	    echo run_group.sh -t $time -s $seed -d ${domain[$c]} -G ${groups[$c]} -L $grid_length -S $speed -A static -% $pgw
	    done
	done
    done
done
