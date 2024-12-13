#include <stdint.h>

#define PIM_SEL_ADDR 0x00000FFC

int main(){
    int a = 50, b = 33, c;
    c = a + b;

    asm volatile ("li a7, 0x00000001");
    asm volatile ("ecall");
   
    volatile uint32_t *PIM_SEL = (volatile uint32_t *) (PIM_SEL_ADDR);

    

    *PIM_SEL = 0x00000000;

    while(1);
    return 0;
}