#$1: nn
#$2: ng
#$3: beacon interval
#$4: speed
#$5: method
#$6: seed
#$7: %

#random_50_10_aa_1_5_3 
#$1 trace file
#$2 control interval
#$3 number of nodes
#$4 number of gateways

#./process_overhead.sh random_$1_$2_aa_1_$4_$5 $3 $1 $2
#./process_method.sh random_$1_$2_aa_1_$4_$5 $3 $1 $2
#for static
#./process_method.sh dynamic_random_$1_$2_1_$4_$5_0 $3 $1 $2 &

rm tmp*
#for dynamic
#./process_method.sh dynamic_random_$1_$2_1_$4_$5_1 $3 $1 $2 &

#for dynamic all
#./process_method.sh dynamic_all_random_$1_2_1_$4_$5_$2 $3 $1 $2

#./process_method.sh dynamic_random_$1_$2_$6_$4_$5_0 $3 $1 $2 
#./process_method.sh dynamic_random_$1_$2_$6_$4_$5_1 $3 $1 $2 
#./process_method.sh dynamic_all_random_$1_2_$6_$4_$5_$7 $3 $1 $2


#./process_overhead.sh dynamic_random_$1_$2_$6_$4_$5_0 $3 $1 $2 
#./process_overhead_dynamic.sh dynamic_random_$1_$2_$6_$4_$5_1 $3 $1 $2 
#./process_overhead_dynamic_all.sh dynamic_all_random_$1_2_$6_$4_$5_$7 $3 $1 $2 

#./process_route.sh dynamic_random_$1_$2_$6_$4_$5_0 $3 $1 $2 
#./process_route.sh dynamic_random_$1_$2_$6_$4_$5_1 $3 $1 $2 
#./process_route.sh dynamic_all_random_$1_2_$6_$4_$5_$7 $3 $1 $2


