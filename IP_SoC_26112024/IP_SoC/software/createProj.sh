mkdir $1
mkdir ./$1/main ./$1/pim
cp buildMainAndPIM.sh hex2mif.py ./$1
cd ./$1
cp ../startup.S ../main_linker.ld ./main
cp ../startup.S ../pim_linker.ld ./pim
