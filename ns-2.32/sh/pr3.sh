#processing..
#$1:result file name
#$2:src
#$3:dst

start=0;
end=100;
interval=1;

while [ "$start" -le $end ]; do

	#echo "start: $start end: $end"

	grep SH_TRF $1 | grep from:\ $2 | grep Id:\ $3 | grep at\ "$start\." | wc | awk '{print $1}' | awk '{print '$start' " " $1*1420*8/1000000}'

	start=$(($start+$interval))

done
