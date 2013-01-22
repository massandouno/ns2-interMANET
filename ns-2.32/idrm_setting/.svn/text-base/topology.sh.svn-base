#$1: number of nodes
#$2: number of domains
#$3: number of gateways in a domain
#$4: single channel T/F

path="./idrm_setting"

g++ -Wall -O2 -o $path/topology.out $path/topology.cc

$path/topology.out $1 $2 $3 $4 > $path/idrm_topology_$1_$2_$3_$4.tcl
