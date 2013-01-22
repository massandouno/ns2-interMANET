#$1: number of nodes
#$2: number of domains
#$3: number of gateways in a domain
#$4: number of traffics
#$5: Beacon interval
##$6: trace_result
#$6: seed
#$7: speed
#$8: method 1:mesh, 2:tree, 3:star
#$9: dynamic 0:static 1:dynamic
#$10: area
#$11: udp rate
#$12: single channel T/F

path="./idrm_setting"
rpath="./result"

if [ $# -ne 12 ]; then
       echo "#of nodes, #of domains, #of gateways, #of traffics, beacon, seed, speed method dynamic area udp_rate single_channel"
       exit 127
fi

gt="$3"

if [ $9 = 1 ]; then
	gt=$(echo "$gt" | awk '{printf "%d\n", $1*2}')
	echo "dynamic gt: $gt"
fi

nn="$1"
nd="$2"

if [ $9 > 1 ]; then
	gt=$(echo "$nn $nd" | awk '{printf "%d\n", $1/$2}')
	echo "dynamic gt: $gt"
fi

#./idrm_setting/random_setting.sh $1 $2 $3 $4
./idrm_setting/random_setting.sh $1 $2 $gt $4 0

#cp $path/idrm_random_traffic.tcl $rpath/random_$1_$gt_$6_$7_$8_$9_traffic.tcl

#print out the current time

echo Startup $algorithm.$try `date`

echo "parameters: $1 $2 $gt $5 $5 o_random_$1_$gt_$6_$7_$8_$9 $6 $7 $8 $9 ${10} ${11} ${12}"
./ns icdcs_group.tcl $1 $2 $gt $5 $5 o_random_$1_$gt_$6_$7_$8_$9 $6 $7 $8 $9 ${10} ${11} ${12} > $rpath/icdcs_group_$1_$2_$3_$5_$6_$7_$8_$9_${10}_${11}_${12}
