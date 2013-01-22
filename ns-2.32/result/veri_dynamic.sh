#$1 after grep "VERIFICATION"
#$2 time
#$3 # of GTs per domain

grep "at $2\." $1 > tmp_at_$1

#cat tmp_at_$1 | awk '{print $5}' > tmp_idrm_rt_$1
cp tmp_at_$1 tmp_idrm_rt_$1

head -25 tmp_idrm_rt_$1 > tmp_first_$1
tail -50 tmp_idrm_rt_$1 | head -25 > tmp_second_$1

cat tmp_second_$1 >> tmp_first_$1
grep "gateway: 1" tmp_first_$1 > ttmp_first_$1

#mv ttmp_first_$1 tmp_idrm_rt_$1
cat ttmp_first_$1 | awk '{print $5}' > tmp_idrm_rt_$1

rt_sum=$(awk '{total+=$0}END{print total}' tmp_idrm_rt_$1)

#gt=$(cat tmp_at_$1 | grep "gateway: 1"  | wc | awk '{print $1}')

gt=$(cat tmp_idrm_rt_$1 | wc | awk '{print $1}')


echo "$rt_sum $gt" | awk '{printf "%f %f\n", $1/$2, $2}'

