#$1: number of nodes
#$2: number of domains
#$3: number of gateways in a domain
#$4: number of traffics
#$5: single_channel T/F

path="./idrm_setting"

echo "nn:$1 nd:$2 ng:$3 nt:$4"
$path/topology.sh $1 $2 $3 $5
$path/ping_traffic.sh $1 $2 $3 $4

#$path/protocol.sh $2
#$path/traffic.sh $1 $4
