.section .startup
.global _start

_start:
    # Initialize Stack Pointer
    la sp, _stack_top

    # Call main 
    call main

    # Infinite Loop 
loop:
    j loop