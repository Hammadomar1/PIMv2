cSrc="$1"
asmStartup="$2"

# Extract the file name without the path
filename=$(basename -- "$cSrc")
filenameAsm=$(basename -- "$asmStartup")

# Extract the name without extension
name="${filename%.*}"
asm="${filenameAsm%.*}"

# echo "NAME: $name \n asm: $asm"

riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -O0 -c "$cSrc" -o "$name.o"  # C to obj
riscv64-unknown-elf-as  -march=rv32im -mabi=ilp32 -o "$asm.o" "$asmStartup" # ASM Startup to obj
riscv64-unknown-elf-ld -T bramlink.ld -m elf32lriscv -nostdlib -nostartfiles -o "$name.elf" "$name.o" "$asm.o" # Link obj to elf

riscv64-unknown-elf-objdump -d -S "$name.elf" > "$name.s"   # Disassemble

# Hex Conversion
riscv64-unknown-elf-objcopy -O binary "$name.elf" a.bin --strip-debug
od -t x4 -An -w4 -v a.bin > "$name.hex"

rm a.bin