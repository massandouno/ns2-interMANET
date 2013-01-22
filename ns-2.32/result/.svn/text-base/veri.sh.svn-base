#$1 after grep "VERIFICATION"
#$2 time
#$3 # of GTs per domain

grep "at $2\." $1 | grep "gateway: 1" | awk '{print $5}' > tmp_at_$1

rt_sum=$(awk '{total+=$0}END{print total}' tmp_at_$1)

gt=$(cat tmp_at_$1 | wc | awk '{print $1}')

echo "$rt_sum $gt" | awk '{printf "%f %f\n", $1/$2, $2}'


