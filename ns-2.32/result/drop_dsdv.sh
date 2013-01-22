#1: trace file

#for dsdv pkt drop
dsdv_n_drop=$(grep "DSDV PKT_N_DROP" $1 | tail -1 | awk '{print $6}')
dsdv_drop=$(grep "DSDV PKT_DROP" $1 | tail -1 | awk '{print $6}')
t_dsdv=$(echo "$dsdv_n_drop $dsdv_drop" | awk '{printf "%f\n", $1+$2}')

echo "$t_dsdv $dsdv_n_drop $dsdv_drop" | awk '{printf "%f %f\n", $2/$1, $3/$1}'