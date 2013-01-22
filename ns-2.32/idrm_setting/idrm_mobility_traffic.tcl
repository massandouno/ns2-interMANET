set traffic(0,src)				5 ; 		set traffic(0,dst)				6 ;
set traffic(0,pksize)				1400 ;
set traffic(0,rate)				1Mb ;
set traffic(0,startoffset)		5.000000 ;

set traffic(1,src)				4 ; 		set traffic(1,dst)				13 ;
set traffic(1,pksize)				1400 ;
set traffic(1,rate)				1Mb ;
set traffic(1,startoffset)		5.000000 ;

set traffic(2,src)				11 ; 		set traffic(2,dst)				13 ;
set traffic(2,pksize)				64 ;
set traffic(2,rate)				1Kb ;
set traffic(2,startoffset)		1.000000 ;

set traffic(3,src)				10 ; 		set traffic(3,dst)				13 ;
set traffic(3,pksize)				64 ;
set traffic(3,rate)				1Kb ;
set traffic(3,startoffset)		20.000000 ;

set traffic(4,src)				9 ; 		set traffic(4,dst)				13 ;
set traffic(4,pksize)				64 ;
set traffic(4,rate)				1Kb ;
set traffic(4,startoffset)		20.000000 ;

set traffic(5,src)				8 ; 		set traffic(5,dst)				13 ;
set traffic(5,pksize)				64 ;
set traffic(5,rate)				1Kb ;
set traffic(5,startoffset)		20.000000 ;

set traffic(6,src)				1 ; 		set traffic(6,dst)				6 ;
set traffic(6,pksize)				64 ;
set traffic(6,rate)				1Kb ;
set traffic(6,startoffset)		2.000000 ;


set nt			7

#for AODV, nt = 4 udp + ping..