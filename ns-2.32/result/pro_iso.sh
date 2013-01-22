#$1: trace

grep "ISO" $1 > tmp_iso_$1

s=$(grep success tmp_iso_$1 | wc | awk '{print $1}')
f=$(grep fail tmp_iso_$1 | wc | awk '{print $1}')

echo "$s $f" | awk '{printf "%f %f %f %f\n", $1, $2, $1/($1+$2), $2/($1+$2)}'

rm tmp_iso_$1
