#!/bin/bash
#generate a topology setting

#$1: number of nodes
#$2: number of gateways
#$3: 


declare -a name
name="ABCDEFGHIJKLMNOPQRSTUVWXYZ"

#a=${name:$offset:1}
#echo $a

x=-500
y=400
distance=250


 if [ $# -ne 3 ]; then
         echo 1>&2 Usage: $0 19 Oct 91
         exit 127
    fi

while [ "$start" -le $end ]; do

	set topo($start,start_x) 							 -400; 										# starting position x
	set topo($start,start_y) 								400; 										# starting position y
	set topo($start,num_if_ch) 								1;										# num interfaces = number of channels. one-to-one mapping between inteface and channels. 
													 																				# Gateway has 2 interfaces while Non-gateways has 1

	set topo($start,idx_map_if_to_ch,0) 				0;  								# mapping interface to channel
	set topo($start,idx_map_if_to_ch,1) 			 -1; 									# mapping interface to channel
	#set topo($start,idx_map_if_to_ragent,0)  	0; 									# mapping interface to routing agent
	set topo($start,idx_map_if_to_ragent,0)  	1; 										# mapping interface to routing agent
	set topo($start,idx_map_if_to_ragent,1) 	 -1; 									# mapping interface to routing agent
	
	set topo($start,my_domain) 								A; 										# set its domain id
	set topo($start,my_identity)	 							0; 									# set its identity: 0 Non-gateway, 1 Gateway
	
	set topo($start,my_gateway,0) 							2;									#Set its gateway nodes: Positive:Gateway nodeId, Negative:NULL
	set topo(0,my_gateway,1) 							1;												#Set its gateway nodes: Positive:Gateway nodeId, Negative:NULL
	
	#for nam
	set nam($start,dom_id)  										A; 									# domain id
	set nam($start,node_id) 										1; 									# node id. MANET_ID = concatenation of dom_id and node_id
	set nam($start,color) 								"black"; 									# color coding for domain id
	set nam($start,shape) 							 "circle"; 									# shape to distnguish regular node (circle), gateway (square)
	
	
	

set topo(1,start_x) -200; # starting position x
set topo(1,start_y) 400; # starting position y
set topo(1,num_if_ch) 2; # num interfaces = number of channels. one-to-one mapping between inteface and channels. 
# Gateway has 2 interfaces while Non-gateways has 1
set topo(1,idx_map_if_to_ch,0) 0;  # mapping interface to channel
set topo(1,idx_map_if_to_ch,1) 3; # mapping interface to channel
#set topo(1,idx_map_if_to_ragent,0)  0; # mapping interface to routing agent
set topo(1,idx_map_if_to_ragent,0)  1; # mapping interface to routing agent
set topo(1,idx_map_if_to_ragent,1)  4; # mapping interface to routing agent

#IDRM_SH
set topo(1,my_domain) A; 		#set its domain id
set topo(1,my_identity) 1; 	#Set its identity: 0 Non-gateway, 1 Gateway

set topo(1,my_gateway,0) 2;	#Set its gateway nodes: Positive:Gateway nodeId, Negative:NULL
set topo(1,my_gateway,1) 1;	#Set its gateway nodes: Positive:Gateway nodeId, Negative:NULL
set topo(1,my_gateway,2) -1;#Set its gateway nodes: Positive:Gateway nodeId, Negative:NULL
set topo(1,my_gateway,3) -1;#Set its gateway nodes: Positive:Gateway nodeId, Negative:NULL
set topo(1,my_gateway,4) -1;#Set its gateway nodes: Positive:Gateway nodeId, Negative:NULL
#IDRM_SH

set nam(1,dom_id)  A; # domain id
set nam(1,node_id) 3; # node id. MANET_ID = concatenation of dom_id and node_id
set nam(1,color) "black"; # color coding for domain id
set nam(1,shape) "square"; # shape to distnguish regular node (circle), gateway (square)	


start=0;
end=100;
interval=1;

while [ "$start" -le $end ]; do

	#echo "start: $start end: $end"

	grep SH_TRF $1 | grep from:\ $2 | grep Id:\ $3 | grep at\ "$start\." | wc | awk '{print $1}' | awk '{print '$start' " " $1*1420*8/1000000}'

	start=$(($start+$interval))

done

