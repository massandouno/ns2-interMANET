#$1 input
awk '{print $5}' $1 | ./avg.pl