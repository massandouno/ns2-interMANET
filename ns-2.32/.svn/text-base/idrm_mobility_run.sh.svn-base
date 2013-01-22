#$1: number of nodes
#$2: number of domains
#$3: number of gateways in a domain
#$4: number of traffics
#$5: eb: eIDRM Beacon interval
#$6: ib: iIDRM Beacon interval
#$7: fn: file name recording the result stat
#$8: trace_result
#$9: seed

path="./idrm_setting"
#rpath="./results"

rpath="/home/shlee/../../mnt/idrmshare2/results"

 if [ $# -ne 9 ]; then
         echo "#of nodes, #of domains, #of gateways, #of traffics, eIDRM beacon, iIDRM beacon, file_name trace_result"
         exit 127
    fi


./idrm_setting/setting.sh $1 $2 $3 $4
cp $path/idrm_mobility_traffic.tcl $rpath/$8_traffic.tcl

./ns idrm_mobility.tcl $1 $2 $3 $5 $6 $7 $9 > $rpath/../$8
