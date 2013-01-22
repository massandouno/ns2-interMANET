n=$(date +%m%d)
cd backup
mkdir $n
cd $n
mkdir aodv
mkdir dsdv
mkdir idrm
mkdir idrm_mobility
cd ..
cd ..

cp ./aodv/*.cc ./backup/$n/aodv/
cp ./aodv/*.h ./backup/$n/aodv/

cp ./dsdv/*.cc ./backup/$n/dsdv/
cp ./dsdv/*.h ./backup/$n/dsdv/

cp ./idrm/*.cc ./backup/$n/idrm/
cp ./idrm/*.h ./backup/$n/idrm/

cp ./tcl/idrm-tcl/*.tcl ./backup/$n/
cp ./tcl/lib/ns-mobilenode.tcl ./backup/$n/
cp ./tcl/lib/ns-lib.tcl ./backup/$n/

cp ./idrm_mobility/m1.tcl ./backup/$n/idrm_mobility/
cp ./idrm_mobility/t1.tcl ./backup/$n/idrm_mobility/
