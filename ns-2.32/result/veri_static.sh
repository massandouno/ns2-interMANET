#$1 after grep "VERIFICATION"

grep "at $2\." $1 > tmp_at_$1
cat tmp_at_$1 | awk '{print $5}' > tmp_idrm_rt_$1
rt_sum=$(awk '{total+=$0}END{print total}' tmp_idrm_rt_$1)

gt=$(cat tmp_at_$1 | grep "gateway: 1"  | wc | awk '{print $1}')

echo "$rt_sum $gt" | awk '{printf "%f %f\n", $1/100.0, $2}'

