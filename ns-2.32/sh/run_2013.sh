#$1:ng
#$2:speed
#$3:area

run_group.sh -t 2500 -s 2 -d 2 -G $1 -L $3 -S $2 -A adaptive -b
run_group.sh -t 2500 -s 2 -d 2 -G $1 -L $3 -S $2 -A static -% 0	
run_group.sh -t 2500 -s 2 -d 2 -G $1 -L $3 -S $2 -A static -% 30
run_group.sh -t 2500 -s 2 -d 2 -G $1 -L $3 -S $2 -A static -% 50
run_group.sh -t 2500 -s 2 -d 2 -G $1 -L $3 -S $2 -A static -% 100

