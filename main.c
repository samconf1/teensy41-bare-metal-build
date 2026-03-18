#include <stdint.h>

#define CCM_CCGR1        (*(volatile uint32_t *)0x400FC06C)
#define IOMUXC_SW_MUX_CTL_PAD_GPIO_B0_03 (*(volatile uint32_t *)0x401F8148)
#define GPIO2_DR         (*(volatile uint32_t *)0x401BC000)
#define GPIO2_GDIR       (*(volatile uint32_t *)0x401BC004)

static void delay(volatile uint32_t n)
{
    while (n--);
}

int main(void)
{
    // Enable GPIO2 clock
    CCM_CCGR1 |= (3 << 26);

    // Mux pin 13 to GPIO (ALT5)
    IOMUXC_SW_MUX_CTL_PAD_GPIO_B0_03 = 5;

    // Set pin as output
    GPIO2_GDIR |= (1 << 3);

    while (1) {
        GPIO2_DR |=  (1 << 3);
        delay(30000000);
        GPIO2_DR &= ~(1 << 3);
        delay(60000000);
    }

    return 0;
}
