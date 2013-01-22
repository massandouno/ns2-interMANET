#$1: nn
#$2: ng
#$3: beacon interval
#$4: speed
#$5: method
#$6: seed
#$7: %
#$8: area ex: 1000x1000
#$9: CBR rate Mbps


#random_50_10_aa_1_5_3 
#$1 trace file
#$2 control interval
#$3 number of nodes
#$4 number of gateways

#dynamic_random_1000x1000_1Mbps_50_12_1_2_1_0
#dynamic_all_500x500_3Mbps_random_50_2_2_2_1_30

#./process_method.sh dynamic_all_$8x$8_$9Mbps_random_$1_2_$6_$4_0_$2 $3 $1 $2
#./process_method.sh dynamic_all_$8x$8_$9Mbps_random_$1_2_$6_$4_1_$7 $3 $1 $2

#./process_overhead.sh dynamic_all_$8x$8_$9Mbps_random_$1_2_$6_$4_0_$2 $3 $1 $2
#./process_overhead.sh dynamic_all_$8x$8_$9Mbps_random_$1_2_$6_$4_1_$7 $3 $1 $2

#./process_method_inDomain2.sh dynamic_all_$8x$8_$9Mbps_random_$1_2_$6_$4_0_$2 $3 $1 $2
#./process_method_inDomain2.sh dynamic_all_$8x$8_$9Mbps_random_$1_2_$6_$4_1_$7 $3 $1 $2

#./process_partition.sh dynamic_all_$8x$8_$9Mbps_random_$1_2_$6_$4_0_$2
./process_partition.sh dynamic_all_$8x$8_$9Mbps_random_$1_2_$6_$4_1_$7
