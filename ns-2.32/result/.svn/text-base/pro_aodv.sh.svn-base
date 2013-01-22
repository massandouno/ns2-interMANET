#$1 trace 

sum=$(grep "AODV C" $1 | tail -1 | awk '{print $13}')
unit=$(echo "$sum" | awk '{printf "%f\n", $1*8/1000000}')

echo "$unit"
