#!/bin/bash
#

time=3000
speed=10:2:10:15:20:10

for seed in 1 2 3
do
    ##### adaptive with beacon adaptation #####
    echo run_group.sh -t $time -S $speed -s $seed -A adaptive -b

    ######## adaptive w/o beacon adaptation ##########
    echo run_group.sh -t $time -S $speed -s $seed -A adaptive

    ######## dynamic ########
    for pgw in 10 50; do
	echo run_group.sh -t $time -S $speed -s $seed -A dynamic -% $pgw
    done

    ######## static ##########
    for pgw in 0 10 50 100; do
	echo run_group.sh -t $time -S $speed -s $seed -A static -% $pgw
    done

done

echo
echo '### after all .data files are collected, do...'
echo 'cd ~/idrm/ns-allinone-2.32/ns-2.32/results/'
echo

for s in 1 2 3 ; do
    echo "plot.sh 6 \"average inter+intra connectivity per active gateway (speed=10:2:10:15:20:10, seed=$s)\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-0_e-10_i-10_s-${s}_L-2300.dat \"NO IDRM\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-10_e-10_i-10_s-${s}_L-2300.dat \"static 10%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-50_e-10_i-10_s-${s}_L-2300.dat \"static 50%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-100_e-10_i-10_s-${s}_L-2300.dat \"static 100%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-1_b-10_e-10_i-10_s-${s}_L-2300.dat \"dynamic 10%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-1_b-50_e-10_i-10_s-${s}_L-2300.dat \"dynamic 50%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-2_b-0_e-10_i-10_s-${s}_L-2300.dat \"adaptive w/o beacon adaptation\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-2_b-1_e-10_i-10_s-${s}_L-2300.dat \"adaptive with beacon adaptation\""
    echo
    echo "plot.sh 5 \"average inter connectivity per active gateway (speed=10:2:10:15:20:10, seed=$s)\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-0_e-10_i-10_s-${s}_L-2300.dat \"NO IDRM\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-10_e-10_i-10_s-${s}_L-2300.dat \"static 10%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-50_e-10_i-10_s-${s}_L-2300.dat \"static 50%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-100_e-10_i-10_s-${s}_L-2300.dat \"static 100%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-1_b-10_e-10_i-10_s-${s}_L-2300.dat \"dynamic 10%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-1_b-50_e-10_i-10_s-${s}_L-2300.dat \"dynamic 50%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-2_b-0_e-10_i-10_s-${s}_L-2300.dat \"adaptive w/o beacon adaptation\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-2_b-1_e-10_i-10_s-${s}_L-2300.dat \"adaptive with beacon adaptation\""
    echo
    echo "plot.sh 2 \"number of active gateways (speed=10:2:10:15:20:10, seed=$s)\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-0_e-10_i-10_s-${s}_L-2300.dat \"NO IDRM\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-10_e-10_i-10_s-${s}_L-2300.dat \"static 10%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-50_e-10_i-10_s-${s}_L-2300.dat \"static 50%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-100_e-10_i-10_s-${s}_L-2300.dat \"static 100%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-1_b-10_e-10_i-10_s-${s}_L-2300.dat \"dynamic 10%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-1_b-50_e-10_i-10_s-${s}_L-2300.dat \"dynamic 50%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-2_b-0_e-10_i-10_s-${s}_L-2300.dat \"adaptive w/o beacon adaptation\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-2_b-1_e-10_i-10_s-${s}_L-2300.dat \"adaptive with beacon adaptation\""
    echo
    echo "plot.sh 2 \"overhead eIDRM out (speed=10:2:10:15:20:10, seed=$s)\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-0_e-10_i-10_s-${s}_L-2300.oh \"NO IDRM\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-10_e-10_i-10_s-${s}_L-2300.oh \"static 10%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-50_e-10_i-10_s-${s}_L-2300.oh \"static 50%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-0_b-100_e-10_i-10_s-${s}_L-2300.oh \"static 100%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-1_b-10_e-10_i-10_s-${s}_L-2300.oh \"dynamic 10%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-1_b-50_e-10_i-10_s-${s}_L-2300.oh \"dynamic 50%\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-2_b-0_e-10_i-10_s-${s}_L-2300.oh \"adaptive w/o beacon adaptation\" \
d-2_G-5_g-5_n-0_t-3000_S-10:2:10:15:20:10_r-5_a-20_A-2_b-1_e-10_i-10_s-${s}_L-2300.oh \"adaptive with beacon adaptation\""
    echo
done
