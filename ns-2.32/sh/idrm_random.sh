#$1: number of nodes
#$2: number of domains
#$3: number of gateways in a domain
#$4: number of traffics
#$5: eb: eIDRM Beacon interval
#$6: ib: iIDRM Beacon interval
#$7: trace_result
#$8: seed
#$9: speed

path="./idrm_setting"
#rpath="./results"

#rpath="/home/shlee/../../mnt/idrmshare2/results"
rpath="."

 if [ $# -ne 9 ]; then
         echo "#of nodes, #of domains, #of gateways, #of traffics, eIDRM beacon, iIDRM beacon, trace_result, seed, speed"
         exit 127
    fi


./idrm_setting/random_setting.sh $1 $2 $3 $4
#cp $path/idrm_mobility_traffic.tcl $8_traffic.tcl

cp $path/idrm_random_traffic.tcl $rpath/random_$1_$3_$7_$8_$9_traffic.tcl

#./ns idrm_one_domain_mobility.tcl $1 $2 $3 $5 $6 o_$1_$3_$7_$8_$9 $8 $9 > $rpath/../$1_$3_$7_$8_$9 #nn_ngt_trace_seed_speed
#./ns idrm_random.tcl $1 $2 $3 $5 $6 o_random_$1_$3_$7_$8_$9 $8 $9 > $rpath/../random_$1_$3_$7_$8_$9 #nn_ngt_trace_seed_speed
./ns idrm_random.tcl $1 $2 $3 $5 $6 o_random_$1_$3_$7_$8_$9 $8 $9 > ./random_$1_$3_$7_$8_$9 #nn_ngt_trace_seed_speed