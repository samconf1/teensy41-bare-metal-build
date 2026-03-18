CC      = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
SIZE    = arm-none-eabi-size

CPU_FLAGS = \
    -mcpu=cortex-m7 \
    -mthumb \
    -mfpu=fpv5-d16 \
    -mfloat-abi=hard

CFLAGS = $(CPU_FLAGS) \
    -O2 \
    -ffunction-sections \
    -fdata-sections \
    -fno-builtin \
    -nostdlib \
    -DARDUINO_TEENSY41 \
    -Wall

LDFLAGS = $(CPU_FLAGS) \
    -T imxrt1062_t41.ld \
    -Wl,--gc-sections \
    -nostdlib

SRCS = main.c startup.c bootdata.c
OBJS = $(SRCS:.c=.o)
TARGET = firmware

all: $(TARGET).hex

$(TARGET).elf: $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@
	$(SIZE) $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex $< $@

flash: $(TARGET).hex
	teensy_loader_cli --mcu=TEENSY41 -w -v $(TARGET).hex

clean:
	rm -f $(OBJS) $(TARGET).elf $(TARGET).hex

.PHONY: all flash clean
