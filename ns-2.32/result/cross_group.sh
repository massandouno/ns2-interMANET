grep UDP $1 > tmptmp_udp_$1

u1=$(grep "from 9" tmptmp_udp_$1 | grep "NodeId: 39" | grep at\ $2\. | wc | awk '{print $1}')
u2=$(grep "from 8" tmptmp_udp_$1 | grep "NodeId: 38" | grep at\ $2\. | wc | awk '{print $1}')
u3=$(grep "from 7" tmptmp_udp_$1 | grep "NodeId: 37" | grep at\ $2\. | wc | awk '{print $1}')
u4=$(grep "from 6" tmptmp_udp_$1 | grep "NodeId: 19" | grep at\ $2\. | wc | awk '{print $1}')
u5=$(grep "from 5" tmptmp_udp_$1 | grep "NodeId: 18" | grep at\ $2\. | wc | awk '{print $1}')
u6=$(grep "from 4" tmptmp_udp_$1 | grep "NodeId: 17" | grep at\ $2\. | wc | awk '{print $1}')

u7=$(grep "from 36" tmptmp_udp_$1 | grep "NodeId: 16" | grep at\ $2\. | wc | awk '{print $1}')
u8=$(grep "from 35" tmptmp_udp_$1 | grep "NodeId: 15" | grep at\ $2\. | wc | awk '{print $1}')
u9=$(grep "from 34" tmptmp_udp_$1 | grep "NodeId: 14" | grep at\ $2\. | wc | awk '{print $1}')
u10=$(grep "from 33" tmptmp_udp_$1 | grep "NodeId: 13" | grep at\ $2\. | wc | awk '{print $1}')

echo "$u1 $u2 $u3 $u4 $u5 $u6 $u7 $u8 $u9 $u10" | awk '{printf "%f %f %f %f %f %f %f %f %f %f\n", $1*1420*8/100000000, $2*1420*8/100000000, $3*1420*8/100000000, $4*1420*8/100000000, $5*1420*8/100000000, $6*1420*8/100000000, $7*1420*8/100000000, $8*1420*8/100000000, $9*1420*8/100000000, $10*1420*8/100000000}'

