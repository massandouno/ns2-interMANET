#!/bin/bash

if [ $# -ne 7 ]; then
    echo "Usage: `basename $0` domain(d) group(G) gateway(g) time(t) speed(S) seed(s) gridLength(L)
       `basename $0` domain(d) group(G) gateway(g) time(t) speed(S) -number_of_seeds_for_aggregation gridLength(L)"
    exit 1
fi

domain=$1
group=$2
gateways=$3
nongateways=0
time=$4
speed=$5
seed=$6
grid_length=$7
low_pgw=20  # should be between (0, 50)

if [ $seed -le 0 ]; then
    seedstr=""
    seedtitle=""
else
    seedstr="s-${seed}_"
    seedtitle="seed ${seed}"
fi

title="domain ${domain} group ${group} gateway 5 nongateway 0 time ${time} speed ${speed} ${seedtitle} area ${grid_length}\n"

dir=/home/hoon/idrm/ns-allinone-2.32/ns-2.32/results
name1=$dir/d-${domain}_G-${group}_g-${gateways}_n-${nongateways}_t-${time}_S-${speed}_r-5_a-20_A-0_b-0_e-10_i-10_${seedstr}L-${grid_length}
name2=$dir/d-${domain}_G-${group}_g-${gateways}_n-${nongateways}_t-${time}_S-${speed}_r-5_a-20_A-0_b-${low_pgw}_e-10_i-10_${seedstr}L-${grid_length}
name3=$dir/d-${domain}_G-${group}_g-${gateways}_n-${nongateways}_t-${time}_S-${speed}_r-5_a-20_A-0_b-50_e-10_i-10_${seedstr}L-${grid_length}
name4=$dir/d-${domain}_G-${group}_g-${gateways}_n-${nongateways}_t-${time}_S-${speed}_r-5_a-20_A-0_b-100_e-10_i-10_${seedstr}L-${grid_length}
name5=$dir/d-${domain}_G-${group}_g-${gateways}_n-${nongateways}_t-${time}_S-${speed}_r-5_a-20_A-2_b-0_e-10_i-10_${seedstr}L-${grid_length}
name6=$dir/d-${domain}_G-${group}_g-${gateways}_n-${nongateways}_t-${time}_S-${speed}_r-5_a-20_A-2_b-1_e-10_i-10_${seedstr}L-${grid_length}

if [ $seed -le 0 ]; then  # average over multiple seeds
    num_of_seeds_to_average=$((0 - $seed))
    average_seeds.sh $num_of_seeds_to_average $domain $group $gateways $time $speed 0   0 $grid_length > ${name1}.avg
    average_seeds.sh $num_of_seeds_to_average $domain $group $gateways $time $speed 0 $low_pgw $grid_length > ${name2}.avg
    average_seeds.sh $num_of_seeds_to_average $domain $group $gateways $time $speed 0  50 $grid_length > ${name3}.avg
    average_seeds.sh $num_of_seeds_to_average $domain $group $gateways $time $speed 0 100 $grid_length > ${name4}.avg
    average_seeds.sh $num_of_seeds_to_average $domain $group $gateways $time $speed 2   1 $grid_length > ${name6}.avg
fi

cap1="NO IDRM"
cap2="Static ${low_pgw}%"
cap3="Static 50%"
cap4="Static 100%"
cap5="Adaptive w/o beacon"
cap6="Adaptive w/ beacon"

echo "Files read:"
echo ${name1}.dat $cap1
echo ${name2}.dat $cap2
echo ${name3}.dat $cap3
echo ${name4}.dat $cap4
echo ${name6}.dat $cap6

if [ $seed -gt 0 ]; then ### for one particular seed

    plottitle="$title Active GW Count"
    plot.sh 2 "$plottitle" ${name1}.dat "$cap1" ${name2}.dat "$cap2" ${name3}.dat "$cap3" ${name4}.dat "$cap4" ${name6}.dat "$cap6"
    
    plottitle="$title Total Connectivity"
    plot.sh 6 "$plottitle"  ${name1}.dat "$cap1" ${name2}.dat "$cap2" ${name3}.dat "$cap3" ${name4}.dat "$cap4" ${name6}.dat "$cap6"
    
    plottitle="$title Beacon Interval"
    plot_beacon_intervals.sh "$plottitle" ${name6}.beacon

fi

tmp_file1=/tmp/tmp_plot_algoritm_"$$"_1.dat
tmp_file2=/tmp/tmp_plot_algoritm_"$$"_2.dat

########## gateway ############
gateways1=$(head -1 ${name1}.avg | awk -F ':' '{print $2}' | awk '{print $1}')
gateways2=$(head -1 ${name2}.avg | awk -F ':' '{print $2}' | awk '{print $1}')
gateways3=$(head -1 ${name3}.avg | awk -F ':' '{print $2}' | awk '{print $1}')
gateways4=$(head -1 ${name4}.avg | awk -F ':' '{print $2}' | awk '{print $1}')
gateways6=$(head -1 ${name6}.avg | awk -F ':' '{print $2}' | awk '{print $1}')
variance1=$(head -1 ${name1}.avg | awk -F ':' '{print $2}' | awk '{print $2+0}')
variance2=$(head -1 ${name2}.avg | awk -F ':' '{print $2}' | awk '{print $2+0}')
variance3=$(head -1 ${name3}.avg | awk -F ':' '{print $2}' | awk '{print $2+0}')
variance4=$(head -1 ${name4}.avg | awk -F ':' '{print $2}' | awk '{print $2+0}')
variance6=$(head -1 ${name6}.avg | awk -F ':' '{print $2}' | awk '{print $2+0}')

echo "Gateway Count:"
echo "[GATEWAY] NO IDRM     : $gateways1 ($variance1)"
echo "[GATEWAY] Static  ${low_pgw}% : $gateways2 ($variance2)"
echo "[GATEWAY] Static  50% : $gateways3 ($variance3)"
echo "[GATEWAY] Static 100% : $gateways4 ($variance4)"
echo "[GATEWAY] Adaptive    : $gateways6 ($variance6)"
echo

echo "title NO-IDRM Static-${low_pgw} Static-50 Static-100 Adaptation" > $tmp_file1
echo "gateway $gateways1 $gateways2 $gateways3 $gateways4 $gateways6" >> $tmp_file1
echo "pos value variance" > $tmp_file2
echo "0.5 $gateways1 $variance1" >> $tmp_file2
echo "1.5 $gateways2 $variance2" >> $tmp_file2
echo "2.5 $gateways3 $variance3" >> $tmp_file2
echo "3.5 $gateways4 $variance4" >> $tmp_file2
echo "4.5 $gateways6 $variance6" >> $tmp_file2

plot_bar.sh "${title} Gateway Count" "Number of Gateways" $tmp_file1 $tmp_file2

########## connectivity ############

inter1=$(head -2 ${name1}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
inter2=$(head -2 ${name2}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
inter3=$(head -2 ${name3}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
inter4=$(head -2 ${name4}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
inter6=$(head -2 ${name6}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
inter_var1=$(head -2 ${name1}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
inter_var2=$(head -2 ${name2}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
inter_var3=$(head -2 ${name3}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
inter_var4=$(head -2 ${name4}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
inter_var6=$(head -2 ${name6}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
intra1=$(head -3 ${name1}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
intra2=$(head -3 ${name2}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
intra3=$(head -3 ${name3}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
intra4=$(head -3 ${name4}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
intra6=$(head -3 ${name6}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
intra_var1=$(head -3 ${name1}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
intra_var2=$(head -3 ${name2}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
intra_var3=$(head -3 ${name3}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
intra_var4=$(head -3 ${name4}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
intra_var6=$(head -3 ${name6}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
total1=$(head -4 ${name1}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
total2=$(head -4 ${name2}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
total3=$(head -4 ${name3}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
total4=$(head -4 ${name4}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
total6=$(head -4 ${name6}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
total_var1=$(head -4 ${name1}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
total_var2=$(head -4 ${name2}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
total_var3=$(head -4 ${name3}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
total_var4=$(head -4 ${name4}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
total_var6=$(head -4 ${name6}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
ntotal1=$(head -5 ${name1}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
ntotal2=$(head -5 ${name2}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
ntotal3=$(head -5 ${name3}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
ntotal4=$(head -5 ${name4}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
ntotal6=$(head -5 ${name6}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $1}')
ntotal_var1=$(head -5 ${name1}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
ntotal_var2=$(head -5 ${name2}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
ntotal_var3=$(head -5 ${name3}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
ntotal_var4=$(head -5 ${name4}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')
ntotal_var6=$(head -5 ${name6}.avg | tail -1 | awk -F ':' '{print $2}' | awk '{print $2+0}')

echo "Connectivity/Gateway: = inter + intra ---- new"
echo "[CONN] NO IDRM     : $total1 ($total_var1) = $inter1 ($inter_var1) + $intra1 ($intra_var1) --- $ntotal1 ($ntotal_var1)"
echo "[CONN] Static ${low_pgw}%  : $total2 ($total_var2) = $inter2 ($inter_var2) + $intra2 ($intra_var2) --- $ntotal2 ($ntotal_var2)"
echo "[CONN] Static 50%  : $total3 ($total_var3) = $inter3 ($inter_var3) + $intra3 ($intra_var3) --- $ntotal3 ($ntotal_var3)"
echo "[CONN] Static 100% : $total4 ($total_var4) = $inter4 ($inter_var4) + $intra4 ($intra_var4) --- $ntotal4 ($ntotal_var4)"
echo "[CONN] Adaptive    : $total6 ($total_var6) = $inter6 ($inter_var6) + $intra6 ($intra_var6) --- $ntotal6 ($ntotal_var6)"
echo

echo "title NO-IDRM Static-${low_pgw} Static-50 Static-100 Adaptation" > $tmp_file1
echo "intra $intra1 $intra2 $intra3 $intra4 $intra6" >> $tmp_file1
echo "inter $inter1 $inter2 $inter3 $inter4 $inter6" >> $tmp_file1
echo "pos value variance" > $tmp_file2
echo "0.5 $total1 $total_var1" >> $tmp_file2
echo "1.5 $total2 $total_var2" >> $tmp_file2
echo "2.5 $total3 $total_var3" >> $tmp_file2
echo "3.5 $total4 $total_var4" >> $tmp_file2
echo "4.5 $total6 $total_var6" >> $tmp_file2

plot_bar.sh "${title} Connectivity" "Connectivity" $tmp_file1 $tmp_file2

############## overhead #################

if [ $seed -gt 0 ]; then  # for one particular seed
    overhead1=$(tail -1 ${name1}.oh | sed -s 's/.*\ //')
    overhead2=$(tail -1 ${name2}.oh | sed -s 's/.*\ //')
    overhead3=$(tail -1 ${name3}.oh | sed -s 's/.*\ //')
    overhead4=$(tail -1 ${name4}.oh | sed -s 's/.*\ //')
    overhead6=$(tail -1 ${name6}.oh | sed -s 's/.*\ //')
    variance1=0
    variance2=0
    variance3=0
    variance4=0
    variance6=0
else # average over all seeds
    overhead1=$(tail -1 ${name1}.avg | awk -F ':' '{print $2}' | awk '{print $1+0}')
    overhead2=$(tail -1 ${name2}.avg | awk -F ':' '{print $2}' | awk '{print $1+0}')
    overhead3=$(tail -1 ${name3}.avg | awk -F ':' '{print $2}' | awk '{print $1+0}')
    overhead4=$(tail -1 ${name4}.avg | awk -F ':' '{print $2}' | awk '{print $1+0}')
    overhead6=$(tail -1 ${name6}.avg | awk -F ':' '{print $2}' | awk '{print $1+0}')
    variance1=$(tail -1 ${name1}.avg | awk -F ':' '{print $2}' | awk '{print $2+0}')
    variance2=$(tail -1 ${name2}.avg | awk -F ':' '{print $2}' | awk '{print $2+0}')
    variance3=$(tail -1 ${name3}.avg | awk -F ':' '{print $2}' | awk '{print $2+0}')
    variance4=$(tail -1 ${name4}.avg | awk -F ':' '{print $2}' | awk '{print $2+0}')
    variance6=$(tail -1 ${name6}.avg | awk -F ':' '{print $2}' | awk '{print $2+0}')
fi

echo "Overhead:"
echo "[OVERHEAD] NO IDRM     : $overhead1 ($variance1)"
echo "[OVERHEAD] Static  ${low_pgw}% : $overhead2 ($variance2)"
echo "[OVERHEAD] Static  50% : $overhead3 ($variance3)"
echo "[OVERHEAD] Static 100% : $overhead4 ($variance4)"
echo "[OVERHEAD] Adaptive    : $overhead6 ($variance6)"
echo

echo "title NO-IDRM Static-${low_pgw} Static-50 Static-100 Adaptation" > $tmp_file1
echo "overhead $overhead1 $overhead2 $overhead3 $overhead4 $overhead6" >> $tmp_file1
echo "pos value variance" > $tmp_file2
echo "0.5 $overhead1 $variance1" >> $tmp_file2
echo "1.5 $overhead2 $variance2" >> $tmp_file2
echo "2.5 $overhead3 $variance3" >> $tmp_file2
echo "3.5 $overhead4 $variance4" >> $tmp_file2
echo "4.5 $overhead6 $variance6" >> $tmp_file2

plot_bar.sh "${title} Overhead" "Overhead" $tmp_file1 $tmp_file2

rm $tmp_file1
rm $tmp_file2
