

path="./idrm_setting"

#traffic.tcl: src, dst info
#$1 trace file

grep src $path/traffic.tcl	| awk '{printf $3 " " $7 "\n"}' > ll

while read myline
do
  src=$(echo $myline | awk '{printf $1}')
  dst=$(echo $myline | awk '{printf $2}')
  
  echo "$src  $dst"
  grep UDP $1 | grep from\ $src | grep :$dst\ 
  
  grep SH_TRF $1 | grep from:\ $src\  | grep NodeId:\ $dst\ 

done < ll			#input file