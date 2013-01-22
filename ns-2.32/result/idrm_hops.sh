 grep "DSDV_IDRM HOP_COUNT" $1  | awk '{print $10}' | ./avg.pl
