#include "stdio.h"
#include "stdlib.h"
#include "time.h"

//argv0: total number of nodes
//argv1: total number of traffics

bool check(int* ar, int val, int size);
	
int main(int argc, char **argv){

	//srand(0);
	//srand(time(0));
		
	int nn = atoi(argv[1]);
	int nt = atoi(argv[2]);
	int src[nt];
	int dst[nt];
	
	for(int i=0; i<nt; i++){
		src[i] = dst[i] = -1;	
	}

	int tmp;


	for(int i=0; i<nt; i++){	
		do{
				tmp = rand() % nn;
		}while(check(src, tmp, nt));

		src[i] = tmp;
	}
	

	for(int i=0; i<nt; i++){	
		do{
				tmp = rand() % nn;
		}while(check(src, tmp, nt) || check(dst, tmp, nt));

		dst[i] = tmp;
	}

	for(int i=0; i<nt; i++){
		printf("set traffic(%d,src)\t\t\t\t%d ; \t\t", i, src[i]);
		printf("set traffic(%d,dst)\t\t\t\t%d ;\n", i, dst[i]);
		printf("set traffic(%d,pksize)\t\t\t\t%d ;\n", i, 1400);
		printf("set traffic(%d,rate)\t\t\t\t%dMb ;\n", i, 2);			//10Mbps
		printf("set traffic(%d,startoffset)\t\t%f ;\n", i, 1.0);	
		printf("\n");
	}

	printf("set nt\t\t\t%d\n", nt);
	
	return 0;	
}


bool check(int* ar, int val, int size){

	for(int i=0; i<size; i++){
		if(ar[i] == val) return true;	
	}
	return false;
}
