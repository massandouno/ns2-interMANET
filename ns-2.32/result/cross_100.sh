
grep UDP $1 > tmp_udp_$1

cat tmp_udp_$1 | grep "from 46" | grep "NodeId: 90" | wc
#grep UDP $1 | grep "from 47" | grep "NodeId: 91" | wc
cat tmp_udp_$1 | grep "from 98" | grep "NodeId: 17" | wc
cat tmp_udp_$1 | grep "from 42" | grep "NodeId: 23" | wc
cat tmp_udp_$1 | grep "from 96" | grep "NodeId: 95" | wc
