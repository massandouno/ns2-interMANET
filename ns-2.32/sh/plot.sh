#!/bin/bash

if [ $# -lt 4 ]; then
    echo "Usage: `basename $0` col_number title file1 title1 [file2 title2 ...]"
    echo "colum number:"
    echo "   for .dat file: active:2, inter:5, total:6"
    echo "   for .oh file : eidrm_out:2, iidrm_out:3, eidrm_in:4, iidrm_in:5"
    exit 1
fi

col=$1
title=$2

shift
shift

PSDIR=~/idrm/ns-allinone-2.32/ns-2.32/results/plot
plotscript=/tmp/tmp_"$$".plt
psfile=$PSDIR/`echo $title | sed -s 's/[\ \(\)]/_/g'`.ps

echo "set title \"$title\"" > $plotscript

echo -n "plot " >> $plotscript
first=1
while [ $# -gt 1 ]
do
	file=$1
	datatitle=$2

    if [ -s $file ]; then
		if [ $first -eq 0 ]; then
			echo -n ", " >> $plotscript
		fi
		echo -n \"$file\" using 1:$col title \"$datatitle\" with steps >> $plotscript
		first=0
    fi
	shift
	shift
done
echo >> $plotscript

if [ $first -ne 0 ]; then
    echo "[Error] No data to plot"
	rm $plotscript
    exit 1;
fi 

echo set size 1,1 >> $plotscript
echo set terminal postscript enhanced color colortext solid \"Helvetica\" 14 >> $plotscript
echo set output \"$psfile\" >> $plotscript
echo replot >> $plotscript
echo set terminal x11 >> $plotscript
echo set size 1,1 >> $plotscript

gnuplot -persist $plotscript

rm $plotscript
echo postscript file $psfile has been created
