set auto x
#set key Left reverse
#set key bottom right
set key below
#set key screen 0.90, 0.93
set xrange [90:1000]
set yrange [0:2.2]
set xlabel "Simulation Time"
set ylabel "UDP Throughput(Mbps)"
#set style data histogram
#set style histogram cluster gap 3
#set style fill solid border -1
#set style fill pattern 9 border 1
#set style histogram errorbars gap 3  lw 3
#set boxwidth 0.9
##set xtic rotate by -45
#set term post eps enhanced "Courier" 24
#set bmargin 10 
set term post eps enhanced color "Courier" 24
set output "s1.eps"

plot "plot1.dat" using 1:2 ti 'w/o IMR' with linespoints lw 3, \
"plot1.dat" using 1:3 ti 'Static' with linespoints lw 3, \
"plot1.dat" using 1:4 ti 'Dynamic' with linespoints lw 3, \
"plot1.dat" using 1:5 ti 'Single DSDV' with linespoints lw 3
