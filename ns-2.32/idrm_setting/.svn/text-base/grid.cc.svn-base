#include "stdio.h"
#include "stdlib.h"
#include "time.h"

//argv0: total number of nodes
//argv1: total number of domains
//argv2: total number of gateways in a domain
	
int main(int argc, char **argv){

	//srand(time(0));
	
	int nn	= atoi(argv[1]);
	int nd	= atoi(argv[2]);
	int ng	= atoi(argv[3]);

	char domain_name = 'A';
	char colors[20][20] = {"blue", "red", "brown", "black", "green", "deeppink", 
										"Cornflowerblue", "Darkred", "tan", "Darkgoldenrod", "Deepskyblue", "Lemonchiffon", "chocolate"};

	int nnd	= nn/nd; 					//number of nodes in a domain
	
	int bx = -1000;
	int by = 1000;

	//int grid_x[4] = {0,1000, 0, 1000};
	//int grid_y[4] = {1000,1000,0,0};
	//int grid_y[4] = {1000,1000,0,0};
	int grid_x[4] = {0, 1000, 0, 1000};
	int grid_y[4] = {1000,1000,500,500};
	
	int x_distance = 200;
	int y_distance = 200;
	
	int x,y;
		
	int idrm_ch		 	= nd;
	int idrm_agent	=	nd+1;
	
	/*
	int range = 500;					//initial area range
	int base_x, base_y;
	int x,y;

	
	int area_x = 1000;
	int area_y = 1000;
	*/
	
	int i,j,k, index;
	int base_x, base_y;

	for(i=0; i<nd; i++){

		base_x = grid_x[i];
		base_y = grid_y[i];
	
		x = base_x;
		y = base_y;
		
		for(j=0; j<ng; j++){
			index = i*nnd + j;

			//for each domain, create a base point
			if( index % 5 == 0){
					x = base_x;
					y -= y_distance;
			}

			//for each domain, create a base point
			
			printf("set topo(%d,start_x)\t\t\t\t%d;\t\t# starting position x\n", index, x);
			printf("set topo(%d,start_y)\t\t\t\t%d;\t\t# starting position y\n", index, y);
			printf("set topo(%d,num_if_ch)\t\t\t\t%d;\t\t# num interfaces = number of channels. one-to-one mapping between inteface and channels.\n",index,2);
			printf("set topo(%d,idx_map_if_to_ch,%d)\t\t\t%d;\t\t# mapping interface to channel\n", index, 0, i);
			printf("set topo(%d,idx_map_if_to_ch,%d)\t\t\t%d;\t\t# mapping interface to channel\n", index, 1, idrm_ch);
			printf("set topo(%d,idx_map_if_to_ragent,%d)\t\t%d;\t\t# mapping interface to routing agent\n", index, 0, i);
			printf("set topo(%d,idx_map_if_to_ragent,%d)\t\t%d;\t\t# mapping interface to routing agent\n", index, 1, idrm_agent);
			printf("set topo(%d,my_domain)\t\t\t\t%c;\t\t#set its domain id\n", index, domain_name);
			printf("set topo(%d,my_identity)\t\t\t\t%d;\t\t#set its identity: 0: non gateway, 1:gateway\n", index, 1);
		
			for( k=0; k<ng; k++){
				printf("set topo(%d,my_gateway,%d)\t\t\t%d;\t\t#Set its gateway nodes: Positive:Gateway nodeId, Negative:NULL\n", index, k, i*nnd+k);	
			}
			
			printf("set nam(%d,dom_id)\t\t\t\t%c;\t\t#domain id\n", index, domain_name);
			printf("set nam(%d,node_id)\t\t\t\t%d;\t\t#domain id\n", index, index);
			printf("set nam(%d,color)\t\t\t\t%s;\t\t#domain id\n", index, colors[i]);
			printf("set nam(%d,shape)\t\t\t\t%s;\t\t#domain id\n", index, "square");
	
			printf("\n");

			x += x_distance;
			

		}

		
		for(j; j<nnd; j++){
			index = i*nnd + j;

			//for each domain, create a base point
			if( index % 5 == 0){
					x = base_x;
					y -= y_distance;
			}
			
			printf("set topo(%d,start_x)\t\t\t\t%d;\t\t# starting position x\n", index, x);
			printf("set topo(%d,start_y)\t\t\t\t%d;\t\t# starting position y\n", index, y);
			printf("set topo(%d,num_if_ch)\t\t\t\t%d;\t\t# num interfaces = number of channels. one-to-one mapping between inteface and channels.\n", index,1);
			printf("set topo(%d,idx_map_if_to_ch,%d)\t\t\t%d;\t\t# mapping interface to channel\n", index, 0, i);
			printf("set topo(%d,idx_map_if_to_ch,%d)\t\t\t%d;\t\t# mapping interface to channel\n", index, 1, -1);
			printf("set topo(%d,idx_map_if_to_ragent,%d)\t\t%d;\t\t# mapping interface to routing agent\n", index, 0, i);
			printf("set topo(%d,idx_map_if_to_ragent,%d)\t\t%d;\t\t# mapping interface to routing agent\n", index, 1, -1);
			printf("set topo(%d,my_domain)\t\t\t\t%c;\t\t#set its domain id\n", index, domain_name);
			printf("set topo(%d,my_identity)\t\t\t\t%d;\t\t#set its identity: 0: non gateway, 1:gateway\n", index, 0);	
		
			for( k=0; k<ng; k++){
				printf("set topo(%d,my_gateway,%d)\t\t\t%d;\t\t#Set its gateway nodes: Positive:Gateway nodeId, Negative:NULL\n", index, k, i*nnd+k);	
			}
			
			printf("set nam(%d,dom_id)\t\t\t\t%c;\t\t#domain id\n", index, domain_name);
			printf("set nam(%d,node_id)\t\t\t\t%d;\t\t#domain id\n", index, index);
			printf("set nam(%d,color)\t\t\t\t%s;\t\t#domain id\n", index, colors[i]);
			printf("set nam(%d,shape)\t\t\t\t%s;\t\t#domain id\n", index, "circle");
		
			printf("\n");
			
			x += x_distance;

		}

		domain_name++;

	
	}

return 0;
}
