#include "stdio.h"
#include "math.h"
#include "stdlib.h"

int main(int argc, char** argv){

	int x1 = atoi(argv[1]);
	int y1 = atoi(argv[2]);
	int x2 = atoi(argv[3]);
	int y2 = atoi(argv[4]);

	int tmp = (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2);
	printf("Distance: %d\n", sqrt(tmp) );

	return 0;
}
