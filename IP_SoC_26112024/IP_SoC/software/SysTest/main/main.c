#include <stdint.h>

#define IO_ADDRESS 0x00000FFC
#define PIM_STAT 0x00001FFC
int main(){
    volatile uint32_t *IO = (volatile uint32_t *) (IO_ADDRESS);
    volatile uint32_t *PIM_SEL = (volatile uint32_t *) (PIM_STAT);

    *IO = 0x00001010;
    *PIM_SEL = 0x00000001;

    *IO = 0x0000A0A0;

    asm volatile ("li a7, 1");
    asm volatile ("ecall");

    while(1);
    return 0; 
}