/* bramlink.ld */

MEMORY
{
    BRAM(rwx): ORIGIN = 0x00000000, LENGTH = 0xFF8
    IO(rw):    ORIGIN = 0x00000FFC, LENGTH = 0x4
}

SECTIONS
{
    everything :
    {
        . = ALIGN(4);
        startup.o(.text)
        *(.*)
    } >BRAM

    .io :
    {
        KEEP(*(.io))
    } > IO
    _stack_top = LENGTH(BRAM) - 8;
}