#$1: file
#$2: src
#$3: dst

grep UDP $1 | grep "from $2" | grep "NodeId: $3" | wc  
