#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: `basename $0` title file"
    echo "colum number:"
    echo "   for .dat file: active:2, inter:5, total:6"
    echo "   for .oh file : eidrm_out:2, iidrm_out:3, eidrm_in:4, iidrm_in:5"
    exit 1
fi

title=$1
file=$2

if [ ! -s $file ]; then
    echo "File $file does not exist or is empty";
    exit 1
fi

PSDIR=~/idrm/ns-allinone-2.32/ns-2.32/results/plot
plotscript=/tmp/tmp_"$$".gnu
intervalfile=/tmp/tmp_"$$".dat
psfile=$PSDIR/`echo $title | sed -s 's/[\ \(\)]/_/g'`.ps

node_count=$(cat $file | awk '{print $5}' | sort | uniq | wc -l)
for (( i=0; i<$node_count; i++ ))
do
	intervals[$i]=10
done
touch $intervalfile
prevtime=0
cat $file | awk '{print $2" "$5" "$19}' | while read time nodeId interval
do
    if [ $time != $prevtime ]; then  ## final value for each timestamp
	for (( i=0; i<$node_count; i++ ))
	do
	    echo ${prevtime}" "${intervals[$i]} >> $intervalfile
	done
	echo >> $intervalfile
    fi
    intervals[$nodeId]=$interval
    prevtime=$time
done

echo "set title \"$title\"" > $plotscript
echo "set nokey" >> $plotscript
echo "set pm3d map" >> $plotscript
echo "splot '$intervalfile' with pm3d"  >> $plotscript
echo set size 1,1 >> $plotscript
echo set terminal postscript enhanced color colortext solid \"Helvetica\" 14 >> $plotscript
echo set output \"$psfile\" >> $plotscript
echo replot >> $plotscript
echo set terminal x11 >> $plotscript
echo set size 1,1 >> $plotscript

gnuplot -persist $plotscript

rm $plotscript
rm $intervalfile
echo postscript file $psfile has been created
