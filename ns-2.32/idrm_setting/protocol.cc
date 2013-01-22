#include "stdio.h"
#include "stdlib.h"

//argv0: total number of domains

bool check(int* ar, int val, int size);
	
int main(int argc, char **argv){

	srand(0);
	
	int nd = atoi(argv[1]);
	int np = 2; //number of protocols
	
	char* proto1 = "AODV";
	char* proto2 = "AODV";
	//char* proto1 = "DSDV";
	//char* proto2 = "DSDV";

	for(int i=0; i<nd; i++){
	
		if( rand() % np == 0 )
			printf("set proto(rp,%d)\t\t%s\n", i, proto1);
		else
			printf("set proto(rp,%d)\t\t%s\n", i, proto2);
	}

	printf("set proto(rp,%d)\t\t%s\n", nd+1, "IDRM");
	printf("set proto(rp,%d)\t\t%s\n", nd+2, "IDRM");
	return 0;
}
