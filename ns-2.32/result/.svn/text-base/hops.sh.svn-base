
grep UDP $1 | grep "from 14" | grep "NodeId: 39" | awk '{print $14}'  | ./avg.pl > tmp_hops_$1
grep UDP $1 | grep "from 15" | grep "NodeId: 40" | awk '{print $14}'  | ./avg.pl >> tmp_hops_$1
grep UDP $1 | grep "from 42" | grep "NodeId: 17" | awk '{print $14}'  | ./avg.pl >> tmp_hops_$1
grep UDP $1 | grep "from 20" | grep "NodeId: 23" | awk '{print $14}'  | ./avg.pl >> tmp_hops_$1
grep UDP $1 | grep "from 38" | grep "NodeId: 41" | awk '{print $14}'  | ./avg.pl >> tmp_hops_$1
./avg.pl tmp_hops_$1
rm tmp_hops_$1
