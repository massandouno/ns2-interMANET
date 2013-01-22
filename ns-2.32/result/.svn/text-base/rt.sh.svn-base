grep "IDRM_SH RT" $1 > tmp_rt_$1 
awk '{print $5}' tmp_rt_$1  | ./avg.pl 
rm tmp_rt_$1
