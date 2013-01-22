<?php
   putenv("TCL_LIBRARY=/home/hwong/www/mobility/code/palm-rw/ns-allinone-2.33/tcl8.4.18/library");
   putenv("LD_LIBRARY_PATH=/home/hwong/www/mobility/code/palm-rw/ns-allinone-2.33/otcl-1.13:/home/hwong/www/mobility/code/palm-rw/ns-allinone-2.33/lib");
   $ns = "/home/hwong/www/mobility/code/palm-rw/ns-allinone-2.33/bin/ns";

   $cmd = "$ns test.tcl 50 1000 1000 6000 rwp_n50_st6000_x1000_y1000_v5.txt.tmp > tmp.txt";
   
   printf("$cmd");
   $r = system($cmd);
   return $r;
?>
