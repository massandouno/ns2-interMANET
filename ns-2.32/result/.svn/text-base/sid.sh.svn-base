grep "at $2.\." $1  | awk '{print $5}' > tmp_rt_$1
grep "at $2.\." $1  | awk '{print $7}' > tmp_hop_$1

sum_rt=$(awk '{total+=$0}END{print total}' tmp_rt_$1)
sum_hops=$(awk '{total+=$0}END{print total}' tmp_hop_$1)

echo "$sum_rt $sum_hops" | awk '{printf "%f %f\n", $1/50.0, $2/50.0}'
