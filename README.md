# rpi-os

Very simple OS example for Raspberry PI.

#### Как собрать бинарник под Raspberry PI:

```bash
arm-none-eabi-as -mcpu=cortex-a7 main.s -o main.o  
arm-none-eabi-ld -Ttext 0x8000 main.o -o main.elf
arm-none-eabi-objcopy main.elf -O binary kernel7.img
```



