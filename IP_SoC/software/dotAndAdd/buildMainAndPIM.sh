# Project Structure

# ./main/*.c        => MAIN C sources
# ./main/*.S        => MAIN Assembly sources
# ./main/linker.ld  => MAIN linker script

# ./PIM/*.c        => PIM C sources
# ./PIM/*.S        => PIM Assembly sources
# ./PIM/linker.ld  => PIM linker script

## MAIN BUILD
cd ./main
riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -O0 -c *.c  # C to obj
riscv64-unknown-elf-as  -march=rv32im -mabi=ilp32 startup.S -o startup.o # ASM Startup to obj
riscv64-unknown-elf-ld -T main_linker.ld -m elf32lriscv -nostdlib -nostartfiles -o main.elf *.o # Link obj to elf

# Hex Conversion
riscv64-unknown-elf-objcopy -O binary main.elf a.bin --strip-debug
od -t x4 -An -w4 -v a.bin > main.hex
rm a.bin
py ../hex2mif.py main.hex main.mif
echo "MAIN BUILT"

## PIM BUILD
cd ../pim
riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -O0 -c *.c  # C to obj
riscv64-unknown-elf-as  -march=rv32im -mabi=ilp32 startup.S -o startup.o # ASM Startup to obj
riscv64-unknown-elf-ld -T pim_linker.ld -m elf32lriscv -nostdlib -nostartfiles -o pim.elf *.o # Link obj to elf

# Hex Conversion
riscv64-unknown-elf-objcopy -O binary pim.elf a.bin --strip-debug
od -t x4 -An -w4 -v a.bin > pim.hex
rm a.bin
py ../hex2mif.py pim.hex pim.mif
echo "PIM BUILT"

cd ..
