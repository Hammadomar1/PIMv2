li s0, 0x30
li s1, 0xDEADBEEF
sw s1, 0(s0)

lw s2, 0(s0)

li a7, 1
ecall