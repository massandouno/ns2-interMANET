#!/bin/bash

#traffic.tcl: src, dst info
#$1 trace file
#$2 control interval
#$3 number of nodes
#$4 number of gateways

spath="./$2"
mkdir $2/final
rpath="$2/final"

ng=$4

#overhead
lines=$(echo "$ng" | awk '{printf "%d\n", $1*2}')
echo $lines

grep "OVERHEAD" $1 | awk '{print $40}' > $rpath/tmpioverhead_$1
grep "OVERHEAD" $1 | awk '{print $37}' > $rpath/tmpeoverhead_$1

tail -$lines $rpath/tmpioverhead_$1 > $rpath/tmptmpioverhead_$1
tail -$lines $rpath/tmpeoverhead_$1 > $rpath/tmptmpeoverhead_$1

awk '{total+=$0}END{print total}' $rpath/tmptmpioverhead_$1 > $rpath/$1_ioverhead
#awk '{total+=$0}END{print total}' $rpath/tmptmpeoverhead_$1 > $rpath/$1_eoverhead


grep n_iidrm $1 | tail -1 | awk '{print $11 }' > $rpath/$1_eoverhead