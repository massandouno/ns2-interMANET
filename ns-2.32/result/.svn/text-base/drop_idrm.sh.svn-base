#1: trace file

#for idrm pkt drop
idrm_n_drop=$(grep "IDRM PKT_N_DROP" $1 | tail -1 | awk '{print $6}')
idrm_drop=$(grep "IDRM PKT_DROP" $1 | tail -1 | awk '{print $6}')
t_idrm=$(echo "$idrm_n_drop $idrm_drop" | awk '{printf "%f\n", $1+$2}')

#for idrm gt drop
gt_n_drop=$(grep "IDRM GT_N_DROP" $1 | tail -1 | awk '{print $6}')
gt_drop=$(grep "IDRM GT_DROP" $1 | tail -1 | awk '{print $6}')
t_gt=$(echo "$gt_n_drop $gt_drop" | awk '{printf "%f\n", $1+$2}')

echo "$t_idrm $idrm_n_drop $idrm_drop $t_gt $gt_n_drop $gt_drop" | awk '{printf "%f %f %f %f\n", $2/$1, $3/$1, $5/$4, $6/$4}'