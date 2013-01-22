
grep UDP $1 | grep "from 95"  | grep "NodeId: 23" | wc
grep UDP $1 | grep "from 149" | grep "NodeId: 99" | wc
grep UDP $1 | grep "from 197" | grep "NodeId: 95" | wc
grep UDP $1 | grep "from 147" | grep "NodeId: 148" | wc
grep UDP $1 | grep "from 190" | grep "NodeId: 192" | wc
