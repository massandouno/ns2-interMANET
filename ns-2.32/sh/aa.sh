#!/bin/bash

if [ $# -lt 6 ]; then
    echo "Usage: `basename $0` title domain group speed seed grid_length"
fi

title=$1
domain=$2
group=$3
gateways=5
nongateways=0
time=2500
speed=$4
seed=$5
grid_length=$6

dir=/home/hoon/idrm/ns-allinone-2.32/ns-2.32/results
param_str1=$dir/d-${domain}_G-${group}_g-${gateways}_n-${nongateways}_t-${time}_S-${speed}_r-5_a-20_A-0_b-0_e-10_i-10_s-${seed}_L-${grid_length}
# param_str2=$dir/d-${domain}_G-${group}_g-${gateways}_n-${nongateways}_t-${time}_S-${speed}_r-5_a-20_A-0_b-10_e-10_i-10_s-${seed}_L-${grid_length}
param_str3=$dir/d-${domain}_G-${group}_g-${gateways}_n-${nongateways}_t-${time}_S-${speed}_r-5_a-20_A-0_b-50_e-10_i-10_s-${seed}_L-${grid_length}
param_str4=$dir/d-${domain}_G-${group}_g-${gateways}_n-${nongateways}_t-${time}_S-${speed}_r-5_a-20_A-0_b-100_e-10_i-10_s-${seed}_L-${grid_length}
#param_str5=$dir/d-${domain}_G-${group}_g-${gateways}_n-${nongateways}_t-${time}_S-${speed}_r-5_a-20_A-2_b-0_e-10_i-10_s-${seed}_L-${grid_length}
param_str6=$dir/d-${domain}_G-${group}_g-${gateways}_n-${nongateways}_t-${time}_S-${speed}_r-5_a-20_A-2_b-1_e-10_i-10_s-${seed}_L-${grid_length}

#plot.sh 2 "${title} Overhead" ${param_str1}.oh "NO IDRM" ${param_str2}.oh "Static 10%" ${param_str3}.oh "Static 50%" ${param_str4}.oh "Static 100%" ${param_str5}.oh "Adap w/o beacon" ${param_str6}.oh "Adap w/ beacon"

plot.sh 2 "${title} Active GW Count" ${param_str1}.dat "NO IDRM" ${param_str3}.dat "Static 50%" ${param_str4}.dat "Static 100%" ${param_str6}.dat "Adap w/ beacon"

#plot.sh '$6-$5' "${title} Intra Connectivity" ${param_str1}.dat "NO IDRM" ${param_str3}.dat "Static 50%" ${param_str4}.dat "Static 100%" ${param_str6}.dat "Adap w/ beacon"

#plot.sh 5 "${title} Inter Connectivity" ${param_str1}.dat "NO IDRM" ${param_str3}.dat "Static 50%" ${param_str4}.dat "Static 100%" ${param_str6}.dat "Adap w/ beacon"

plot.sh 6 "${title} Total Connectivity" ${param_str1}.dat "NO IDRM" ${param_str3}.dat "Static 50%" ${param_str4}.dat "Static 100%" ${param_str6}.dat "Adap w/ beacon"

#echo ${param_str1}.avg
cat ${param_str1}.avg > no_idrm
no_idrm_gw=$(cat no_idrm | head -1 | awk '{print $4}')
no_idrm_con=$(cat no_idrm | tail -1 | awk '{print $3}')
no_idrm_oh=$(tail -n 1 ${param_str1}.oh | awk '{print $2}')
echo "$no_idrm_gw $no_idrm_con $no_idrm_oh"

cat ${param_str3}.avg > s50
s50_gw=$(cat s50 | head -1 | awk '{print $4}')
s50_con=$(cat s50 | tail -1 | awk '{print $3}')
s50_oh=$(tail -n 1 ${param_str3}.oh | awk '{print $2}')
echo "$s50_gw $s50_con $s50_oh"

cat ${param_str6}.avg > ad
ad_gw=$(cat ad | head -1 | awk '{print $4}')
ad_con=$(cat ad | tail -1 | awk '{print $3}')
ad_oh=$(tail -n 1 ${param_str6}.oh | awk '{print $2}')
echo "$ad_gw $ad_con $ad_oh"

cat ${param_str4}.avg > s100
s100_gw=$(cat s100 | head -1 | awk '{print $4}')
s100_con=$(cat s100 | tail -1 | awk '{print $3}')
s100_oh=$(tail -n 1 ${param_str4}.oh | awk '{print $2}')
echo "$s100_gw $s100_con $s100_oh"


#cat s100
cat ${param_str1}.avg
echo " "
cat ${param_str3}.avg
echo " "
cat ${param_str6}.avg
echo " "
cat ${param_str4}.avg
echo " "
rm no_idrm s50 s100 ad
