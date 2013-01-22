#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Usage: `basename $0` plot_title y_title datafile [varience_file]"
    exit 1
fi
title=$1
y_title=$2
datafile=$3
if [ $# -eq 4 ]; then
    variencefile=$4
    plot_varience=1
else
    plot_varience=0
fi

PSDIR=~/idrm/ns-allinone-2.32/ns-2.32/results/plot
plotscript=/tmp/tmp_"$$".gnu
psfile=$PSDIR/`echo $title | sed -s 's/[\ \(\)]/_/g'`.ps

echo "set title \"$title\"" > $plotscript
echo set xlabel \"Algorithms\" >> $plotscript
echo set ylabel \"$y_title\" >> $plotscript
echo set boxwidth 0.5 absolute >> $plotscript
echo set grid noxtics nomxtics ytics nomytics noztics nomztics nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics >> $plotscript
echo set grid layerdefault   linetype 0 linewidth 1.000,  linetype 0 linewidth 1.000 >> $plotscript
echo set key inside left top vertical Left reverse enhanced autotitles columnhead box linetype -1 linewidth 1.000 >> $plotscript
echo set style fill solid 0.5 border -1 >> $plotscript
echo set style histogram columnstacked title offset character 0, 0, 0 >> $plotscript
echo set style data histograms >> $plotscript
echo set datafile missing \'-\' >> $plotscript
echo set yrange [ 0.00000 : \* ] noreverse nowriteback >> $plotscript

columns=$(head -1 $datafile | wc -w)
echo -n "plot '$datafile' using 2:key(1) title col" >> $plotscript

for (( i=3; i<=$columns; i++ ))
do
    echo -n ", '' using $i title col" >> $plotscript
done

if [ $plot_varience -eq 1 ] && [ -s $variencefile ] ; then
    echo ", '$variencefile' using 1:2:3 title 'varience' with yerrorbars linetype -1" >> $plotscript
else
    echo >> $plotscript
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
