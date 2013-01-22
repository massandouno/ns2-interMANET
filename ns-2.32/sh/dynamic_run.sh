#$1: seed $2: speed


./sh_idrm_dynamic.sh 50 2 2 5 10 $1 $2 1 0 &
./sh_idrm_dynamic.sh 50 2 2 5 10 $1 $2 1 1 
./sh_idrm_dynamic_all.sh 50 2 2 5 10 $1 $2 1 10

./sh_idrm_dynamic.sh 50 2 5 5 10 $1 $2 1 0 &
./sh_idrm_dynamic.sh 50 2 5 5 10 $1 $2 1 1 
./sh_idrm_dynamic_all.sh 50 2 2 5 10 $1 $2 1 20

./sh_idrm_dynamic.sh 50 2 7 5 10 $1 $2 1 0 &
./sh_idrm_dynamic.sh 50 2 7 5 10 $1 $2 1 1 
./sh_idrm_dynamic_all.sh 50 2 2 5 10 $1 $2 1 30

./sh_idrm_dynamic.sh 50 2 12 5 10 $1 $2 1 0 &
./sh_idrm_dynamic.sh 50 2 12 5 10 $1 $2 1 1 
./sh_idrm_dynamic_all.sh 50 2 2 5 10 $1 $2 1 50
