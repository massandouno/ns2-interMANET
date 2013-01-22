#$1: trace file

grep n_iidrm $1 | awk '{print $7}' > tmp_ioverhead_$1
grep n_iidrm $1 | awk '{print $11}' > tmp_eoverhead_$1

eo=$(awk '{total+=$0}END{print total}' tmp_eoverhead_$1)
io=$(awk '{total+=$0}END{print total}' tmp_ioverhead_$1)

./cross.sh $1 | awk '{print $1}' > tmp_udp_$1
udp=$(awk '{total+=$0}END{print total}' tmp_udp_$1)

udp_f=$(echo "$udp" | awk '{printf "%f\n", $1*1420/100000000}')

echo "$udp_f $eo $io" 