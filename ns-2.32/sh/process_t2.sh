#$1 input
#$2: duration
#$3: interval

#[AGENT SH]IDRM NodeId: 9 receiving UDP from 2 pid: 3189 to 9 hops: 1 at 68.273898

interval=$3;

start=0;
end=$2;

traffic=0;
current=0;
current_interval=1;

grep "UDP" $1 > $1_udp
grep "from 0" $1_udp | grep "NodeId: 3" > $1_udp1
grep "from 5" $1_udp | grep "NodeId: 10" > $1_udp2
					
while [ "$start" -le "$end" ]; do
  	
  	current=0;
  	sum1=0;
  	sum2=0;
  	
  	while [ "$current" -lt "$interval" ]; do
  		
  		now=$(($start+$current))
			  		
			t1=$(grep "at $now\." $1_udp1 | wc | awk '{print $1}')
			t2=$(grep "at $now\." $1_udp2 | wc | awk '{print $1}')
			
			sum1=$(($sum1+$t1))
			sum2=$(($sum2+$t2))
			
			current=$(($current+1))
		
		done
				
		start=$(($start+$interval))
		
		udp1=$(echo "$sum1 $interval" | awk '{printf "%d\n", $1*1000*8.0/$2/1000.0}')
		udp2=$(echo "$sum2 $interval" | awk '{printf "%d\n", $1*1000*8.0/$2/1000.0}')

		echo "$start $udp1 $udp2 $(($udp1+$udp2))"

#		echo "$sum1 $interval $start $flow" | awk '{printf "<e2e time=\"%d\" flow=\"%d\" bytes=\"%d\" />\n", $3, 0,  $1*1420*8.0/$2/1000.0}' >> $1_e2e
#		echo "$sum2 $interval $start $flow" | awk '{printf "<e2e time=\"%d\" flow=\"%d\" bytes=\"%d\" />\n", $3, 1,  $1*1420*8.0/$2/1000.0}' >> $1_e2e		
				
done
