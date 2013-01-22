#!/usr/bin/perl -w


#$1: number of nodes
#$2: number of gateways
#$3: number of domains

$domain_name='A';											#domain name
@colors=("blue", "red", "chocolate", "brown", "tan", "gold", "black", "green", "yellow");

$nn=$ARGV[0];											#total number of nodes
$ng=$ARGV[1];											#total number of gateways in a domain
$nd=$ARGV[2];											#total number of domains

$npd=$nn/$nd;											#total number of nodes in a domain

$array[1]++;

$base_x=-500;
$base_y=400;
$distance=200;

$random_x=0;
$random_y=0;

$if_id=0;
$ch_id=0;

$idrm_ch=$npd+1;
$idrm_agent=$npd+2;


$i=0;

for( $current_domain=0; $current_domain<$nd; $current_domain++){

	for( $k=0; $k<$ng; $k++ ) {
		$i=$k+($current_domain*$npd);
		$random_x+=$distance;
		
		printf("set topo(%d,start_x)\t\t\t\t%d;\t\t# starting position x\n", $i, $base_x+$random_x);
		printf("set topo(%d,start_y)\t\t\t\t%d;\t\t# starting position y\n", $i, $base_y+$random_y);
		printf("set topo(%d,num_if_ch)\t\t\t\t%d;\t\t# num interfaces = number of channels. one-to-one mapping between inteface and channels.\n", $i,2);
		printf("set topo(%d,idx_map_if_to_ch,%d)\t\t\t%d;\t\t# mapping interface to channel\n", $i, 0, $current_domain);
		printf("set topo(%d,idx_map_if_to_ch,%d)\t\t\t%d;\t\t# mapping interface to channel\n", $i, 1, $idrm_ch);
		printf("set topo(%d,idx_map_if_to_ragent,%d)\t\t%d;\t\t# mapping interface to routing agent\n", $i, 0, $current_domain);
		printf("set topo(%d,idx_map_if_to_ragent,%d)\t\t%d;\t\t# mapping interface to routing agent\n", $i, 1, $idrm_agent);
		printf("set topo(%d,my_domain)\t\t\t\t%s;\t\t#set its domain id\n", $i, $domain_name);
		printf("set topo(%d,my_identity)\t\t\t\t%d;\t\t#set its identity: 0: non gateway, 1:gateway\n", $i, 1);
	
		for( $j=0; $j<$ng; $j++){
			printf("set topo(%d,my_gateway,%d)\t\t\t%d;\t\t#Set its gateway nodes: Positive:Gateway nodeId, Negative:NULL\n", $i, $j, $current_domain*$npd+$j);	
		}
		
		printf("set nam(%d,dom_id)\t\t\t\t%s;\t\t#domain id\n", $i, $domain_name);
		printf("set nam(%d,node_id)\t\t\t\t%s;\t\t#domain id\n", $i, $i);
		printf("set nam(%d,color)\t\t\t\t%s;\t\t#domain id\n", $i, $colors[$current_domain]);
		printf("set nam(%d,shape)\t\t\t\t%s;\t\t#domain id\n", $i, "square");

		printf("\n");
	}

	for($k; $k<$npd; $k++){
		$i=$k+($current_domain*$npd);
		$random_x+=$distance;
		
		printf("set topo(%d,start_x)\t\t\t\t%d;\t\t# starting position x\n", $i, $base_x+$random_x);
		printf("set topo(%d,start_y)\t\t\t\t%d;\t\t# starting position y\n", $i, $base_y+$random_y);
		printf("set topo(%d,num_if_ch)\t\t\t\t%d;\t\t# num interfaces = number of channels. one-to-one mapping between inteface and channels.\n", $i,1);
		printf("set topo(%d,idx_map_if_to_ch,%d)\t\t\t%d;\t\t# mapping interface to channel\n", $i, 0, $current_domain);
		printf("set topo(%d,idx_map_if_to_ch,%d)\t\t\t%d;\t\t# mapping interface to channel\n", $i, 1, -1);
		printf("set topo(%d,idx_map_if_to_ragent,%d)\t\t%d;\t\t# mapping interface to routing agent\n", $i, 0, $current_domain);
		printf("set topo(%d,idx_map_if_to_ragent,%d)\t\t%d;\t\t# mapping interface to routing agent\n", $i, 1, -1);
		printf("set topo(%d,my_domain)\t\t\t\t%s;\t\t#set its domain id\n", $i, $domain_name);
		printf("set topo(%d,my_identity)\t\t\t\t%d;\t\t#set its identity: 0: non gateway, 1:gateway\n", $i, 0);	
	
		for( $j=0; $j<$ng; $j++){
			printf("set topo(%d,my_gateway,%d)\t\t\t%d;\t\t#Set its gateway nodes: Positive:Gateway nodeId, Negative:NULL\n", $i, $j, $current_domain*$npd+$j);	
		}
		
		printf("set nam(%d,dom_id)\t\t\t\t%s;\t\t#domain id\n", $i, $domain_name);
		printf("set nam(%d,node_id)\t\t\t\t%s;\t\t#domain id\n", $i, $i);
		printf("set nam(%d,color)\t\t\t\t%s;\t\t#domain id\n", $i, $colors[$current_domain]);
		printf("set nam(%d,shape)\t\t\t\t%s;\t\t#domain id\n", $i, "circle");
	
		printf("\n");
	}

	$domain_name++;

}
