#!/bin/bash
#
NSBIN=`which ns`
NSDIR=`dirname $NSBIN`
scriptname=`basename $0`
CURRENTDIR=`pwd`

## set defaults
num_of_domains=2
num_of_groups_per_domain=5
num_of_gateways_per_group=5
num_of_nongateways_per_group=0
simulation_time=1000
speedStr=20
speed_randomness=5
angle_randomness=20
algorithm=adaptive
percentage_gateway=100
beacon_interval_adaptive=0
interval_ebeacon=10
interval_ibeacon=10
seed=1
grid_length=2300
display_in_nam=0
debug_mode=0

while getopts ":d:G:g:n:t:S:r:a:A:%:e:i:s:L:bXDh" opt; do
    case $opt in
	d)
	    num_of_domains=$OPTARG
	    ;;
	G)
	    num_of_groups_per_domain=$OPTARG
	    ;;
	g)
	    num_of_gateways_per_group=$OPTARG
	    ;;
	n)
	    num_of_nongateways_per_group=$OPTARG
	    ;;
	t)
	    simulation_time=$OPTARG
	    ;;
	S)
	    speedStr=$OPTARG
	    ;;
	r)
	    speed_randomness=$OPTARG
	    ;;
	a)
	    angle_randomness=$OPTARG
	    ;;
	A)
	    algorithm=$OPTARG
	    ;;
	%)
	    percentage_gateway=$OPTARG
	    ;;
	e)
	    interval_ebeacon=$OPTARG
	    ;;
	i)
	    interval_ibeacon=$OPTARG
	    ;;
	s)
	    seed=$OPTARG
	    ;;
	L)
	    grid_length=$OPTARG
	    ;;
	b)
	    beacon_interval_adaptive=1
	    ;;
	X)
	    display_in_nam=1
	    ;;
	D)
	    debug_mode=1
	    ;;
	h)
	    echo "
Usage:

  $scriptname [OPTION]...

OPTIONS:

    COMMON OPTIONS:
    ---------------
    -A ARG : {static|dynamic|adaptive}          (default $algorithm)

    -S ARG : speed of group leaders             (default $speedStr)
             ARG Examples
             20           20
             10-20        randomly selected from [10,20]
             10:20        10 at time [0,T/2), and 20 at time [T/2,T]
             10-20:20:30  [10,20] at time [0,T/3), and so on

    -d ARG : number of domains                  (default $num_of_domains)
    -G ARG : number of groups per domain        (default $num_of_groups_per_domain)
    -g ARG : number of gateways per group       (default $num_of_gateways_per_group)
    -n ARG : number of non-gateways per group   (default $num_of_nongateways_per_group)
    -t ARG : simulation time in seconds         (default $simulation_time)
    -r ARG : speed randomness                   (default $speed_randomness)
    -a ARG : angle randomness                   (default $angle_randomness)
    -e ARG : initial ebeacon-interval           (default $interval_ebeacon)
    -i ARG : initial ibeacon-interval           (default $interval_ibeacon)
    -s ARG : seed                               (default $seed)
    -L ARG : length of the grid                 (default $grid_length)

    -D     : debug mode (keeps dump file, nam file, tr file around for debugging)
    -X     : display simulation in nam
    -h     : display usage and exit

    ALGORITHM SPECIFIC OPTIONS:
    ---------------------------
    static and dynamic:
             -% ARG : % of active gateways in a domain [0-100] (default $percentage_gateway)

    adaptive:
             -b     : use adaptive beacon interval instead of fixed beacon interval.
                      to set initial beacon intervals, see -e and -i flags

EXAMPLES:

    $scriptname -A static -% 10 -S 10:20:30 -t 1500
    $scriptname -A adaptive -S 10:20:30 -t 1500
    $scriptname -A adaptive -b -S 10:20:30 -t 1500
    $scriptname -d 5 -G 20 -g 1 -n 0   # random mobility since group size (g+n) = 1
"
      exit 0
      ;;
	
	\?)
	    echo "Invalid option: -$OPTARG" >&2
	    echo "Run $scriptname -h for usage" >&2
	    exit 1
	    ;;
	:)
	    echo "Option -$OPTARG requires an argument" >&2
	    echo "Run $scriptname -h for usage" >&2
	    exit 1
	    ;;
    esac
done

if [ $algorithm == "adaptive" ]; then
	dynamic=2
	percentage_gateway=$beacon_interval_adaptive ### HACK: percentage_gateway={0,1} is repurposed to beacon adaptation in NS
elif [ $algorithm == "dynamic" ]; then
	dynamic=1
elif [ $algorithm == "static" ]; then
	dynamic=0
else
	echo "Invalid algorithm ${algorithm}. Valid algorithms are {static|dynamic|adaptive}"
	exit 1
fi

param_str=d-${num_of_domains}_G-${num_of_groups_per_domain}_g-${num_of_gateways_per_group}_n-${num_of_nongateways_per_group}_t-${simulation_time}_S-${speedStr}_r-${speed_randomness}_a-${angle_randomness}_A-${dynamic}_b-${percentage_gateway}_e-${interval_ebeacon}_i-${interval_ibeacon}_s-${seed}_L-${grid_length}

echo "Started time: "`date +%T`
echo "output file name: "${param_str}

dump_file=$NSDIR/dump_files/${param_str}.dump
trace_file=$NSDIR/dump_files/${param_str}.tr
nam_file=$NSDIR/dump_files/${param_str}.nam
conn_aggregate_file=$NSDIR/results/${param_str}.dat
beacon_interval_file=$NSDIR/results/${param_str}.beacon
conn_average_file=$NSDIR/results/${param_str}.avg
overhead_file=$NSDIR/results/${param_str}.oh

num_of_nodes_per_group=$(($num_of_nongateways_per_group + $num_of_gateways_per_group));
num_of_groups=$(($num_of_groups_per_domain * $num_of_domains));

if [ $num_of_nodes_per_group -eq 1 ]; then  ### random mobility (group size = 1 ; everyone is in its own group)

    cd $NSDIR

    if [ ! -f random/${param_str}.position ]; then
	echo "[Error] Required file 'random/${param_str}.position' is not found"
	cd $CURRENTDIR
	exit 1
    fi

    if [ ! -f random/${param_str}.movement ] ; then
	echo "[Error] Required file 'random/${param_str}.movement' is not found"
	cd $CURRENTDIR
	exit 1
    fi

    echo "Running NS..."
    ns random/random_mobility.tcl $grid_length $grid_length $seed $num_of_domains $num_of_groups_per_domain $dynamic $percentage_gateway $interval_ebeacon $interval_ibeacon $simulation_time $param_str > $dump_file 2>/dev/null

else ### group mobility

    movement_file=$NSDIR/group/${param_str}.movement
    position_file=$NSDIR/group/${param_str}.position

    cd $NSDIR/group
    echo "Running RPGM..."
    if ./rpgm $grid_length $grid_length $seed $simulation_time $speedStr $num_of_groups $num_of_nodes_per_group $speed_randomness $angle_randomness $param_str ; then
	echo "RPGM Finished"
    else
	if [ $debug_mode -ne 0 ]; then
	    echo "[Debug] .movement, .position files are created for debugging purpose"
	else
	    rm -f $position_file
	    rm -f $movement_file
	fi
	
	cd $CURRENTDIR
	exit 1
    fi

    cd $NSDIR
    echo "Running NS..."
    ns group/icdcs_random.tcl $grid_length $grid_length $seed $num_of_domains $num_of_groups_per_domain $num_of_gateways_per_group $num_of_nongateways_per_group $dynamic $percentage_gateway $interval_ebeacon $interval_ibeacon $simulation_time $param_str > $dump_file 2>/dev/null

    if [ $debug_mode -eq 0 ]; then
	rm -f $position_file
	rm -f $movement_file
    fi

fi

echo "Counting overhead..."
count_overhead.sh $dump_file > $overhead_file
echo "Created overhead statistics file  : $overhead_file"

if [ $algorithm == "static" ] && [ $percentage_gateway == 0 ] ; then
    active_only=0;
else
    active_only=1;
fi

echo "Parseing beacon interval changes..."
parse_beacon_interval.sh $dump_file > $beacon_interval_file
echo "Created beacon interval dump file : $beacon_interval_file"

echo "Counting connectivity..."
count_connectivity.sh $active_only $dump_file > $conn_aggregate_file
echo "Created connectivity aggregation file : $conn_aggregate_file"

echo "Calculating the average..."
count_average.sh $conn_aggregate_file | tee $conn_average_file
echo "Created statistical average file : $conn_average_file"

if [ $display_in_nam -ne 0 ]; then
    nam $nam_file 2>/dev/null 1>&2
fi

if [ $debug_mode -ne 0 ]; then
    echo "[Debug] .dump, .tr, .nam, .movement, .position files are created for debugging purpose"
else
    rm -f $dump_file
    rm -f $trace_file
    rm -f $nam_file
fi

cd $CURRENTDIR
echo "Finished time: "`date +%T`
