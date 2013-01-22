#$1: total number of domains

path="./idrm_setting"

g++ $path/protocol.cc
mv a.out $path/protocol.out
$path/protocol.out $1 > $path/protocol.tcl