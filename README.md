# rpi-os

Very simple OS example for Raspberry PI.

#### Как собрать бинарник под Raspberry PI 2:

```bash
arm-none-eabi-as -mcpu=cortex-a7 source/main.s -o main.o  
arm-none-eabi-ld -Ttext 0x8000 main.o -o main.elf
arm-none-eabi-objcopy main.elf -O binary kernel7.img
```

#### Как собрать бинарник под Raspberry PI 5:

Установка ARM GNU Toolchain на MacOS:

```bash
brew install aarch64-elf-gcc
```

Сборка проекта:

```bash
aarch64-elf-as -o boot.o source/boot.S
aarch64-elf-as -o main.o source/main.s

aarch64-elf-ld -Ttext 0x80000 -o kernel.elf boot.o main.o
aarch64-elf-objcopy -O binary kernel.elf kernel_2712.img
```
