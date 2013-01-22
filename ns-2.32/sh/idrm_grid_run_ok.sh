#$1: number of nodes
#$2: number of domains
#$3: number of gateways in a domain
#$4: number of traffics
#$5: eb: eIDRM Beacon interval
#$6: ib: iIDRM Beacon interval
#$7: fn: file name recording the result stat


 if [ $# -ne 7 ]; then
         echo "#of nodes, #of domains, #of gateways, #of traffics, eIDRM beacon, iIDRM beacon, file_name"
         exit 127
    fi


./idrm_setting/setting.sh $1 $2 $3 $4
#./ns info.tcl $1 $2 $3 $5 $6 $7
./ns idrm_grid_ok.tcl $1 $2 $3 $5 $6 $7
