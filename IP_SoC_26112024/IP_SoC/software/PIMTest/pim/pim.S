li s0, 4088
li s1, 0x600DF00D
sw s1, (0)s0

li s0, 4092
li s1, 0
sw s1, (0)s0

li a7, 1
ecall

loop: j loop