#!/bin/bash

#traffic.tcl: src, dst info
#$1 trace file
#$2 control interval
#$3 number of nodes
#$4 number of gateways

spath="./$2"
mkdir $2/final
rpath="$2/final"

ng="$4"

cp ./sh_traffic_$3 $spath/$1_traffic.tcl

echo "s_path: $spath r_path: $rpath"
nt=5						#number of traffics

grep src $spath/$1_traffic.tcl	| awk '{printf $3 " " $7 "\n"}' > $rpath/tmptraffic_ll_$1

head -$nt $rpath/tmptraffic_ll_$1 > $rpath/ttmptraffic_ll_$1
mv $rpath/ttmptraffic_ll_$1 $rpath/tmptraffic_ll_$1

grep startoffset $spath/$1_traffic.tcl	| awk '{printf $3 "\n"}' > $rpath/tmptraffic_offset_$1
head -$nt $rpath/tmptraffic_offset_$1 > $rpath/ttmptraffic_offset_$1
mv $rpath/ttmptraffic_offset_$1 $rpath/tmptraffic_offset_$1

start=0;
end=1000;

traffic=0;
current=0;
current_interval=1;


grep "IDRM_SH RT" $1 | awk '{print $5}' > $rpath/tmproutes_$1
route=$(awk '{total+=$0}END{print total}' $rpath/tmproutes_$1)
ct=$(grep "IDRM_SH RT" $1 | tail -1 | awk '{print $9}')
echo "route: $route count: $ct"

#echo "$route $ng" | awk '{printf "%f\n", $1/$2/100/4}' > $rpath/$1_route
echo "$route $ct" | awk '{printf "%f\n", $1/$2}' > $rpath/$1_route