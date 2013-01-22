#$1: number of nodes
#$2: number of domains
#$3: number of gateways in a domain
#$4: number of traffics

path="./idrm_setting"

echo "nn:$1 nd:$2 ng:$3 nt:$4"
$path/topology.sh $1 $2 $3
#$path/protocol.sh $2
$path/traffic.sh $1 $4