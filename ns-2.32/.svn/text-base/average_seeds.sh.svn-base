#!/bin/bash

if [ $# -ne 9 ]; then
    echo "Usage : $0 num_of_seeds domain group gateways time speed A b grid_length"
    exit 1
fi

num_of_seeds=$1
d=$2
G=$3
g=$4
n=0
t=$5
S=$6
r=5
a=20
A=$7
b=$8
e=10
i=10
L=$9

dir=/home/hoon/idrm/ns-allinone-2.32/ns-2.32/results
tmpfile=/tmp/tmp_"$$".dat


seed1name=$dir/d-${d}_G-${G}_g-${g}_n-${n}_t-${t}_S-${S}_r-${r}_a-${a}_A-${A}_b-${b}_e-${e}_i-${i}_s-1_L-${L}
linecount=$(cat ${seed1name}.avg | wc -l)

for (( linenum=1 ; $linenum <= $linecount ; linenum++ ))
do
    [ -f $tmpfile ] && rm $tmpfile

    for (( seed=1 ; $seed <= $num_of_seeds ; seed++ ))
    do
	name=$dir/d-${d}_G-${G}_g-${g}_n-${n}_t-${t}_S-${S}_r-${r}_a-${a}_A-${A}_b-${b}_e-${e}_i-${i}_s-${seed}_L-${L}
	head -n ${linenum} ${name}.avg | tail -1 | sed -s 's/.*\ //' >> $tmpfile
    done
    title=$(head -n ${linenum} ${seed1name}.avg | tail -1 | sed -s 's/:.*/:/')
    echo -n "$title "
    awk -f ~/ns/var.awk $tmpfile
done

[ -f $tmpfile ] && rm $tmpfile
for (( seed=1 ; $seed <= $num_of_seeds ; seed++ ))
do
    name=$dir/d-${d}_G-${G}_g-${g}_n-${n}_t-${t}_S-${S}_r-${r}_a-${a}_A-${A}_b-${b}_e-${e}_i-${i}_s-${seed}_L-${L}
    tail -1 ${name}.oh | sed -s 's/.*\ //' >> $tmpfile
done
echo -n "Overhead: "
awk -f ~/ns/var.awk $tmpfile

rm $tmpfile
