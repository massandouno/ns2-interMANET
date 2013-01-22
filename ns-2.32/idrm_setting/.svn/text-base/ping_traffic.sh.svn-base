#$1: number of nodes
#$2: number of domains
#$3: number of gateways in a domain
#$4: number of traffics

path="./idrm_setting"

g++ -Wall -O2 -o $path/ping_traffic $path/ping_traffic.cc 

$path/ping_traffic $1 $2 $3 $4 > $path/$1_$2_$3_$4_ping_traffic.tcl



