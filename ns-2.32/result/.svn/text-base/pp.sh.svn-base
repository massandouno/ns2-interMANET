#$1: trace file
#$2: # of nodes
#$3: # of gts


grep "OVERHEAD" $1 > tmp_overhead_$1
cat tmp_overhead_$1 | awk '{print $40}' | tail -$2 | head -$3 > tmp_ioverhead_$1
cat tmp_overhead_$1 | awk '{print $37}' | tail -$2 | head -$3 > tmp_eoverhead_$1

eo=$(awk '{total+=$0}END{print total}' tmp_eoverhead_$1 | awk '{printf "%f\n", $1*8/2700000000}')
io=$(awk '{total+=$0}END{print total}' tmp_ioverhead_$1 | awk '{printf "%f\n", $1*8/2700000000}')

./cross_$2\.sh $1 | awk '{print $1}' > tmp_udp_$1
udp=$(awk '{total+=$0}END{print total}' tmp_udp_$1)

udp_f=$(echo "$udp" | awk '{printf "%f\n", $1*1420*8/2700000000}')

rm tmp*$1
#echo "$udp_f $eo $io $ibo" 
echo "$udp_f $eo $io" 
