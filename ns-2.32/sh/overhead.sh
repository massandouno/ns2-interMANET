#!/bin/bash

#traffic.tcl: src, dst info
#$1 trace file
#$2 number of gateways

#spath="./$2"
#mkdir $2/final
#rpath="$2/final"

ng=$2

#overhead
lines=$(echo "$ng" | awk '{printf "%d\n", $1}')
#echo $lines

grep "OVERHEAD" $1 | awk '{print $40}' > tmpioverhead_$1
grep "OVERHEAD" $1 | awk '{print $37}' > tmpeoverhead_$1

tail -$lines tmpioverhead_$1 > tmptmpioverhead_$1
tail -$lines tmpeoverhead_$1 > tmptmpeoverhead_$1

awk '{total+=$0}END{print total}' tmptmpioverhead_$1 > tmptmptmpioverhead_$1
awk '{total+=$0}END{print total}' tmptmpeoverhead_$1 > tmptmptmpeoverhead_$1


iover=$(cat tmptmptmpioverhead_$1 | awk '{printf "%f\n", $1*8/1000000000}')
eover=$(cat tmptmptmpeoverhead_$1 | awk '{printf "%f\n", $1*8/1000000000}')

echo "eoverhead: $eover ioverhead: $iover"



