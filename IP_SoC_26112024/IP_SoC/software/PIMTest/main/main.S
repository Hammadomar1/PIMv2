li s0, 4088
li s1, 0xDEADBEEF
sw s1, (0)s0

li s0, 8184
li s1, 1
sw s1, (0)s0

li a7, 1
ecall

loop: j loop