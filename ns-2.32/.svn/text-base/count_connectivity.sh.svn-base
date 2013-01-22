#!/bin/bash

if [ $# -ne 2 ]; then
    echo "
  Usage : $0 active_only /path/to/dump/file.

  Output format:
  time active_gateway_count inter_total inter+intra_total inter_per_(active)_gateway inter+intra_per_(active)_gateway
    "
    exit 1
fi

active_only=$1
node_count=`grep -o "^STAT NodeId: [0-9]\+" $2 | sort | uniq | wc -l`  # num of nodes

## initialize array ##
for (( i=0; i<$node_count; i++ ))
do
	nodeTotalArr[$i]=0
	nodeInterArr[$i]=0
	nodeTotalArrNew[$i]=0
	nodeActiveArr[$i]=0
	nodeCounted[$i]=0
done

prev_time=0
intersum=0
totalsum=0
newtotalsum=0
activecount=0
count=0
grep "^STAT NodeId" $2 | sed -s 's/,//g' | awk '{print $13" "$3" "$5" "$9" "$11" "$15}' | while read time nodeId active nodeTotal nodeInter nodeTotalNew
do
    if [ ${nodeCounted[$nodeId]} -ne 1 ]; then
	nodeCounted[$nodeId]=1
	count=$(($count+1))
    fi

    if [ ${nodeActiveArr[$nodeId]} -ne $active ]; then
        if [ $active -eq 1 ]; then # inactive => active
            activecount=$(($activecount+1))
        else                       # active   => inactive
            activecount=$(($activecount-1))
        fi
    fi

    if [ $active_only -eq 1 ] && [ $active -eq 0 ]; then
	nodeTotal=0
	nodeInter=0
	nodeTotalNew=0
    fi

    totalsum=$(($totalsum - ${nodeTotalArr[$nodeId]} + $nodeTotal))
    intersum=$(($intersum - ${nodeInterArr[$nodeId]} + $nodeInter))
    newtotalsum=$(($newtotalsum - ${nodeTotalArrNew[$nodeId]} + $nodeTotalNew))
    
    nodeTotalArr[$nodeId]=$nodeTotal
    nodeInterArr[$nodeId]=$nodeInter
    nodeTotalArrNew[$nodeId]=$nodeTotalNew
    nodeActiveArr[$nodeId]=$active
    if [ $time != $prev_time ]; then  ## final value for each timestamp

  	if [ $active_only -eq 1 ]; then
	    count_for_average=$activecount
	else
	    count_for_average=$count
	fi

  	if [ $count_for_average -eq 0 ]; then
 	    echo $time $activecount $intersum $totalsum 0 0 0
	else
  	    echo $time $activecount $intersum $totalsum `echo $intersum $totalsum $newtotalsum ${count_for_average} | awk '{printf "%f %f %f", $1/$4, $2/$4, $3/$4}'`
	fi
    fi

    prev_time=$time
done
